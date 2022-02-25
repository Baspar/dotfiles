set -g DICT_TMP_FILE "__baspar_tmp_file"
set -g DICT_PID "__baspar_pid"
set -g DICT_ID "__baspar_id"

function setup_indicator -a indicator_name pre_async_fn async_fn async_cb_fn list_fn
  _dict_set $DICT_TMP_FILE $indicator_name (mktemp)

  function __baspar_indicator_update_$indicator_name -a delta -V indicator_name -V list_fn -V async_fn -V async_cb_fn -V pre_async_fn
    set list (eval $list_fn); or return
    set count (count $list)

    if [ $delta -gt 0 ]
      set id (_dict_get $DICT_ID $indicator_name)
      _dict_setx $DICT_ID $indicator_name (math $id % $count + 1)
    end

    set id (_dict_get $DICT_ID $indicator_name)
    set item $list[$id]

    eval $pre_async_fn $item

    # Kill running async function
    if _dict_has $DICT_PID $indicator_name
      kill -9 (_dict_get $DICT_PID $indicator_name) &> /dev/null
    end

    set file (_dict_get $DICT_TMP_FILE $indicator_name)
    command fish --private --command "$async_fn '$item' '$file'" &

    set pid (jobs --last --pid)
    _dict_set $DICT_PID $indicator_name

    function __baspar_update_async_callback_$indicator_name -V indicator_name -V pid -V async_cb_fn --on-process-exit $pid
      eval $async_cb_fn (_dict_get $DICT_TMP_FILE $indicator_name)
      _dict_rem $DICT_PID $indicator_name
      commandline -f repaint
    end
  end

  function __baspar_indicator_cycle_$indicator_name -V indicator_name
    if _dict_has $DICT_ID $indicator_name
      __baspar_indicator_update_$indicator_name 1
      commandline -f repaint
    end
  end

  function __baspar_indicator_display_$indicator_name -V indicator_name -V list_fn
    if _dict_has $DICT_ID $indicator_name
      set id (_dict_get $DICT_ID $indicator_name)
      set list (eval $list_fn)
      set item $list[$id]
      set count (count $list)

      set fg_color "#000000"
      if _dict_has $DICT_PID $indicator_name
        set fg_color "#666666"
      end

      block "#AF875F" $fg_color " $item" -o -i
      block (__baspar_darker_of "#AF875F") "#3e3e3e" "$id/$count" -o
    end
  end

  function __baspar_indicator_init_$indicator_name -V indicator_name
    if ! _dict_has $DICT_ID $indicator_name
      _dict_setx $DICT_ID $indicator_name 1
      __baspar_indicator_update_$indicator_name 0
    end
  end
end

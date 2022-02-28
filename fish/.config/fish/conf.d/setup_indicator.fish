bind -M insert ' ' 'commandline -i " "; commandline -f expand-abbr; __baspar_check_special_command_fn'
bind -M insert \c] '__baspar_indicator_cycle'
bind -M insert \cp '__baspar_indicator_select'

set -g __baspar_indicator_commands

set -g DICT_TMP_FILE "__baspar_tmp_file"
set -g DICT_PID "__baspar_pid"
set -g DICT_ID "__baspar_id"

function setup_indicator -a indicator_name logo pre_async_fn async_fn async_cb_fn list_fn
  _dict_set $DICT_TMP_FILE $indicator_name (mktemp)

  function __baspar_indicator_update_$indicator_name -a item -V indicator_name -V list_fn -V async_fn -V async_cb_fn -V pre_async_fn
    set item (echo $item | string unescape --style=var)
    eval $pre_async_fn "$item"
    commandline -f repaint

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

  function __baspar_indicator_select_$indicator_name -V indicator_name -V list_fn -V async_fn -V async_cb_fn -V pre_async_fn
    set list (eval $list_fn); or return

    printf "%s\n" $list \
        | cat -n \
        | fzf --height 10 --with-nth 2.. \
        | string trim \
        | read -l -d \t id item; or return
    _dict_setx $DICT_ID $indicator_name $id

    eval __baspar_indicator_update_$indicator_name (echo $item | string escape --style=var)
  end

  function __baspar_indicator_increment_$indicator_name -a delta -V indicator_name -V list_fn -V async_fn -V async_cb_fn -V pre_async_fn
    set list (eval $list_fn); or return
    set count (count $list)

    if [ $delta -gt 0 ]
      set id (_dict_get $DICT_ID $indicator_name)
      _dict_setx $DICT_ID $indicator_name (math $id % $count + 1)
    end

    set id (_dict_get $DICT_ID $indicator_name)
    set item $list[$id]

    eval __baspar_indicator_update_$indicator_name (echo $item | string escape --style=var)
  end

  function __baspar_indicator_cycle_$indicator_name -V indicator_name
    if _dict_has $DICT_ID $indicator_name
      __baspar_indicator_increment_$indicator_name 1
      commandline -f repaint
    end
  end

  function __baspar_indicator_display_$indicator_name -V indicator_name -V list_fn -V logo
    if _dict_has $DICT_ID $indicator_name
      set id (_dict_get $DICT_ID $indicator_name)
      set list (eval $list_fn)
      set item $list[$id]
      set count (count $list)

      set fg_color "#000000"
      if _dict_has $DICT_PID $indicator_name
        set fg_color "#666666"
      end

      block "#AF875F" $fg_color "$logo$item" -o -i
      block (__baspar_darker_of "#AF875F") "#3e3e3e" "$id/$count" -o
    end
  end

  function __baspar_indicator_init_$indicator_name -V indicator_name
    if ! _dict_has $DICT_ID $indicator_name
      _dict_setx $DICT_ID $indicator_name 1
      __baspar_indicator_increment_$indicator_name 0
    end
  end
end

function __baspar_check_special_command_fn
  set commands (commandline | sed -E 's/;|&&|\|\||\||; *(and|or)|env +([^ ]+=[^ ]+ +)*/\n/g' | string trim | cut -d' ' -f1)

  for command in $__baspar_indicator_commands
    if contains $command $commands
      set -g __baspar_indicator_show_$command
    else
      set -e __baspar_indicator_show_$command
    end
  end

  commandline -f repaint
end

function __baspar_indicator_select
  for command in $__baspar_indicator_commands
    if set -q __baspar_indicator_show_$command
      eval __baspar_indicator_select_$command
      break
    end
  end
end

function __baspar_indicator_cycle
  for command in $__baspar_indicator_commands
    if set -q __baspar_indicator_show_$command
      eval __baspar_indicator_cycle_$command
      break
    end
  end
end

function __baspar_indicator_display
  for command in $__baspar_indicator_commands
    if set -q __baspar_indicator_show_$command
      eval __baspar_indicator_display_$command
      break
    end
  end
end

function __baspar_indicator_init
  if set -q __baspar_indicator_init_done
    return
  end

  for command_file in ~/.config/fish/prompt_indicators/*.fish
    set command (basename $command_file .fish)
    source $command_file
    set __baspar_indicator_commands $__baspar_indicator_commands $command
    eval __baspar_indicator_init_$command
  end

  set -g __baspar_indicator_init_done
end

# Need to be pre-loaded for the async command
status is-interactive; or __baspar_indicator_init

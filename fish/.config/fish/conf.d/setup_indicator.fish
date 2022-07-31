bind -M insert ' ' 'commandline -i " "; commandline -f expand-abbr; __baspar_indicator_check'
bind -M insert \ca 'commandline -f accept-autosuggestion; __baspar_indicator_check'
bind -M insert \c] '__baspar_indicator_cycle'
bind -M insert \cp '__baspar_indicator_select'
bind -M insert \c_ '__baspar_indicator_err'

set -g __baspar_indicator_names

set -g DICT_TMP_FILE "__baspar_tmp_file"
set -g DICT_PID "__baspar_pid"
set -g DICT_ID "__baspar_id"
set -g DICT_ERR "__baspar_err"
set -g DICT_COMMAND "__baspar_cmd"
set -g DICT_LIST "__baspar_list"
set -g DICT_OVERRIDE_NAME "__baspar_override_name"

# Alias a command to a indicator name
function setup_indicator_alias -a command_name indicator_name
  _dict_setx $DICT_COMMAND $command_name $indicator_name
end

# Create all underlying function for specific `indicator_name`
function setup_indicator -a indicator_name logo pre_async_fn async_fn async_cb_fn list_fn
  _dict_set $DICT_TMP_FILE $indicator_name (mktemp)
  _dict_rem $DICT_LIST $indicator_name
  set __baspar_indicator_names $__baspar_indicator_names $indicator_name
  setup_indicator_alias $indicator_name $indicator_name

  # Call provided list_fn once and return the memoized response
  function __baspar_indicator_mem_list_$indicator_name -V indicator_name -V list_fn
    if ! _dict_has $DICT_LIST $indicator_name
      _dict_setx $DICT_LIST $indicator_name "$(eval $list_fn)"
    end
    _dict_get $DICT_LIST $indicator_name
  end

  function __baspar_indicator_update_$indicator_name -a item -V indicator_name -V async_fn -V async_cb_fn -V pre_async_fn
    set item (echo $item | string unescape --style=var)
    $pre_async_fn "$item"
    commandline -f repaint

    # Kill running async function
    if _dict_has $DICT_PID $indicator_name
      functions -e __baspar_update_async_callback_$indicator_name
      kill -9 (_dict_get $DICT_PID $indicator_name) &> /dev/null
    end

    set file (_dict_get $DICT_TMP_FILE $indicator_name)
    command fish --private --command "$async_fn '$item' '$file'" 2> $file.err &

    set pid (jobs --last --pid)
    _dict_setx $DICT_PID $indicator_name $pid

    function __baspar_update_async_callback_$indicator_name -V file -V indicator_name -V pid -V async_cb_fn --on-process-exit $pid
      _dict_rem $DICT_PID $indicator_name
      set error_code $argv[3]
      functions -e __baspar_indicator_err_$indicator_name
      if [ $error_code -eq 0 ]
        _dict_rem $DICT_ERR $indicator_name
        $async_cb_fn (_dict_get $DICT_TMP_FILE $indicator_name)
      else
        _dict_set $DICT_ERR $indicator_name "$error_code - $pid"
        function __baspar_indicator_err_$indicator_name -V file -V error_code -V indicator_name
          echo -e "\n$indicator_name:"
          echo -e "error_code: $error_code"
          cat $file.err
          echo ""
          commandline -f repaint
        end
      end
      rm -rf $file
      commandline -f repaint
    end
  end

  function __baspar_indicator_select_$indicator_name -V indicator_name
    set list (eval __baspar_indicator_mem_list_$indicator_name); or return

    printf "%s\n" $list \
        | cat -n \
        | fzf --height 10 --with-nth 2.. \
        | string trim \
        | read -l -d \t id item; or return
    _dict_setx $DICT_ID $indicator_name $id

    __baspar_indicator_update_$indicator_name (echo $item | string escape --style=var)
  end

  function __baspar_indicator_increment_$indicator_name -a delta -V indicator_name
    set list (eval __baspar_indicator_mem_list_$indicator_name); or return
    set count (count $list)

    if [ $delta -gt 0 ]
      set id (_dict_get $DICT_ID $indicator_name)
      _dict_setx $DICT_ID $indicator_name (math $id % $count + 1)
    end

    set id (_dict_get $DICT_ID $indicator_name)
    set item $list[$id]

    __baspar_indicator_update_$indicator_name (echo $item | string escape --style=var)
  end

  function __baspar_indicator_end_override_$indicator_name -a override_name -V indicator_name
    _dict_setx $DICT_OVERRIDE_NAME $indicator_name $override_name
  end

  function __baspar_indicator_start_override_$indicator_name -a override_item -V indicator_name
    _dict_setx $DICT_ID $indicator_name 0

    __baspar_indicator_update_$indicator_name (echo $override_item | string escape --style=var)
  end

  function __baspar_indicator_logo_$indicator_name -V logo -V indicator_name
    if _dict_has $DICT_PID $indicator_name
      set_color "white"
      echo -n "$logo"
    else if _dict_has $DICT_ERR $indicator_name
      set_color "#AF5F5E"
      echo -n "$logo"
    end
    set_color normal
  end

  function __baspar_indicator_cycle_$indicator_name -V indicator_name
    __baspar_indicator_increment_$indicator_name 1
    commandline -f repaint
  end

  function __baspar_indicator_display_$indicator_name -V indicator_name -V logo
    set id (_dict_get $DICT_ID $indicator_name)
    set list (eval __baspar_indicator_mem_list_$indicator_name); or return
    if [ $id -gt 0 ]
      set item $list[$id]
    else if _dict_has $DICT_OVERRIDE_NAME $indicator_name
      set item (_dict_get $DICT_OVERRIDE_NAME $indicator_name)
    else
      set item "???"
    end
    set count (count $list)

    set fg_color "#000000"
    if _dict_has $DICT_PID $indicator_name
      set fg_color "#666666"
    end

    set bg_color "#AF875F"
    if _dict_has $DICT_ERR $indicator_name
      set bg_color "#AF5F5E"
    end

    section $bg_color $fg_color "$logo$item" -o -i
    if [ $id -gt 0 ]
      section (__baspar_darker_of $bg_color) "#3e3e3e" "$id/$count" -o
    end
  end

  function __baspar_indicator_init_$indicator_name -V indicator_name
    _dict_setx $DICT_ID $indicator_name 1
    __baspar_indicator_increment_$indicator_name 0
  end
end

# Search current commandline for indicator_name/alias and call corresponding `__baspar_indicator_show_*`
function __baspar_indicator_check
  set commands (commandline | sed -E 's/;|&&|\|\||\||; *(and|or)|env +([^ ]+=[^ ]+ +)*/\n/g' | string trim | cut -d' ' -f1)

  for indicator in $__baspar_indicator_names
      set -e __baspar_indicator_show_$indicator
  end

  for command in (_dict_keys $DICT_COMMAND)
    if contains $command $commands
      set -g __baspar_indicator_show_(_dict_get $DICT_COMMAND $command)
    end
  end

  commandline -f repaint
end

function __baspar_indicator_select
  for command in $__baspar_indicator_names
    if set -q __baspar_indicator_show_$command
      eval __baspar_indicator_select_$command
      break
    end
  end
end

function __baspar_indicator_cycle
  for command in $__baspar_indicator_names
    if set -q __baspar_indicator_show_$command
      eval __baspar_indicator_cycle_$command
      break
    end
  end
end

function __baspar_indicator_display
  for command in $__baspar_indicator_names
    if ! set -q __baspar_indicator_show_$command
      eval __baspar_indicator_logo_$command
    end
  end

  for command in $__baspar_indicator_names
    if set -q __baspar_indicator_show_$command
      eval __baspar_indicator_display_$command
      return
    end
  end
end

function __baspar_indicator_err
  for command in $__baspar_indicator_names
    if set -q __baspar_indicator_show_$command && _dict_has $DICT_ERR $command
      eval __baspar_indicator_err_$command
      break
    end
  end
end

function __baspar_indicator_init
  set -q __baspar_indicator_init_done && return
  set -g __baspar_indicator_init_done

  for command in $__baspar_indicator_names
    eval __baspar_indicator_init_$command
  end
end

for command_file in ~/.config/fish/prompt_indicators/*.fish
  source $command_file
end

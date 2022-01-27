# ================
# Indicators (AWS)
# ================

set -g __baspar_aws_tmp_file (mktemp)

function __baspar_indicator_update_async_aws -a AWS_PROFILE __baspar_aws_tmp_file
  set AWS_REGION (env AWS_PROFILE=$AWS_PROFILE aws configure get region 2>/dev/null)

  echo "$AWS_REGION" > $__baspar_aws_tmp_file
end

function __baspar_indicator_update_aws -a delta
  set AWS_PROFILES ([ -f ~/.aws/credentials ] && cat ~/.aws/credentials | sed '/^\[.*\]$/!d; s/\[\(.*\)\]/\1/'); or return
  if [ $delta -gt 0 ]
    set count (count $AWS_PROFILES)
    set -gx __baspar_aws_id (math $__baspar_aws_id % $count + 1)
  end
  set -gx AWS_PROFILE $AWS_PROFILES[$__baspar_aws_id]

  # Kill running async function
  if set -q __baspar_aws_update_pid
    kill -9 $__baspar_aws_update_pid
  end

  command fish --private --command "__baspar_indicator_update_async_aws '$AWS_PROFILE' '$__baspar_aws_tmp_file'" 2>&1 > /dev/null &
  set -g __baspar_aws_update_pid (jobs --last --pid)

  functions -e __baspar_update_aws_async_callback
  function __baspar_update_aws_async_callback -V __baspar_aws_tmp_file --on-process-exit $__baspar_aws_update_pid
    set async_response (cat $__baspar_aws_tmp_file)

    set -gx AWS_REGION $async_response[1]

    set -e __baspar_aws_update_pid

    commandline -f repaint
  end
end

function __baspar_indicator_cycle_aws
  if [ $AWS_PROFILE ]
    __baspar_indicator_update_aws 1
    commandline -f repaint
  end
end

function __baspar_indicator_display_aws
  if [ $AWS_PROFILE ]
    set AWS_PROFILES (cat ~/.aws/credentials | sed '/^\[.*\]$/!d; s/\[\(.*\)\]/\1/')
    set count (count $AWS_PROFILES)

    set AWS_FG_COLOR "#000000"
    if set -q __baspar_aws_update_pid
      set AWS_FG_COLOR "#666666"
    end
    block "#AF875F" $AWS_FG_COLOR " $AWS_PROFILE" -o -i
    block (__baspar_darker_of "#AF875F") "#3e3e3e" "$__baspar_aws_id/$count" -o
  end
end

function __baspar_indicator_init_aws
  if ! set -q __baspar_aws_id
    set -gx __baspar_aws_id 1
    __baspar_indicator_update_aws 0
  end
end

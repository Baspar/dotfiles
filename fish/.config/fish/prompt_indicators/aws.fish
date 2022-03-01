# ================
# Indicators (AWS)
# ================

function __baspar_indicator_list_aws
  [ -f ~/.aws/credentials ] && cat ~/.aws/credentials | sed '/^\[.*\]$/!d; s/\[\(.*\)\]/\1/'
end

function __baspar_indicator_pre_async_aws -a item
  set -gx AWS_PROFILE $item
end

function __baspar_indicator_async_aws -a AWS_PROFILE response_file
  set AWS_REGION (env AWS_PROFILE=$AWS_PROFILE aws configure get region 2> /dev/null); or return 1
  set AWS_ACCOUNT (env AWS_PROFILE=$AWS_PROFILE aws sts get-caller-identity --query Account --output text 2> /dev/null); or return 1
  set AWS_DEV (env AWS_PROFILE=$AWS_PROFILE aws configure get dev 2> /dev/null); or return 1

  echo "$AWS_REGION" > $response_file
  echo "$AWS_ACCOUNT" >> $response_file
  echo "$AWS_DEV" >> $response_file
end

function __baspar_indicator_async_cb_aws -a response_file
  set async_response (cat $response_file)

  set -gx AWS_REGION $async_response[1]
  set -gx AWS_ACCOUNT_ID $async_response[2]
  set AWS_DEV $async_response[3]

  if [ -n "$AWS_DEV" ]
    set -gx DEV_AWS_ACCOUNT $AWS_ACCOUNT_ID
  else
    set -e DEV_AWS_ACCOUNT
  end
end

setup_indicator aws " " \
  __baspar_indicator_pre_async_aws \
  __baspar_indicator_async_aws \
  __baspar_indicator_async_cb_aws \
  __baspar_indicator_list_aws

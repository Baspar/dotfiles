# ================
# Indicators (AWS)
# ================

function __baspar_indicator_list_aws
  aws configure list-profiles
end

function __baspar_indicator_pre_async_aws -a item
  set -gx AWS_PROFILE $item
end

function __baspar_indicator_async_aws -a AWS_PROFILE response_file
  set -fx AWS_PROFILE $AWS_PROFILE

  set AWS_REGION (aws configure get region)
  set AWS_ACCOUNT (aws sts get-caller-identity --query Account --output text); or return 2
  set AWS_DEV (aws configure get dev)

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

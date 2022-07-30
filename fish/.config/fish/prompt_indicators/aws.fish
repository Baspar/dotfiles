# ================
# Indicators (AWS)
# ================

function __baspar_indicator_list_aws
  aws configure list-profiles
end

function __baspar_indicator_pre_async_aws -a credentials
  if string match "|*|*|*|" "$credentials" > /dev/null
    set -e AWS_PROFILE
  else
    set -gx AWS_PROFILE $credentials
  end
end

function __baspar_indicator_async_aws -a credentials response_file
  if string match "|*|*|*|" "$credentials" > /dev/null
    set -fx AWS_ACCESS_KEY_ID (echo $credentials | cut -d'|' -f 2)
    set -fx AWS_SECRET_ACCESS_KEY (echo $credentials | cut -d'|' -f 3)
    set -fx AWS_SESSION_TOKEN (echo $credentials | cut -d'|' -f 4)
  else
    set -fx AWS_PROFILE $credentials
  end

  set AWS_REGION (aws configure get region; or echo "eu-west-1")
  set AWS_ACCOUNT (aws sts get-caller-identity --query Account --output text); or exit 2
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

if status is-interactive
  function __baspar_indicator_override_aws --on-variable AWS_ACCESS_KEY_ID --on-variable AWS_SECRET_ACCESS_KEY --on-variable AWS_SESSION_TOKEN
    if [ -n "$AWS_ACCESS_KEY_ID" ] && [ -n "$AWS_SECRET_ACCESS_KEY" ] && [ -n "$AWS_SESSION_TOKEN" ]
      __baspar_indicator_start_override_aws "|$AWS_ACCESS_KEY_ID|$AWS_SECRET_ACCESS_KEY|$AWS_SESSION_TOKEN|"
    end
  end
end

# ================
# Indicators (AWS)
# ================

function __baspar_indicator_list_aws
  [ -f ~/.aws/credentials ] && cat ~/.aws/credentials | sed '/^\[.*\]$/!d; s/\[\(.*\)\]/\1/'
end

function __baspar_indicator_pre_async_aws -a credentials
  if string match "|*|*|*|" "$credentials" > /dev/null
    set -e AWS_PROFILE
  else
    set -gx AWS_PROFILE $credentials
    set -e AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN
  end
end

function __baspar_indicator_async_aws -a credentials response_file
  set is_overriden
  if string match "|*|*|*|" "$credentials" > /dev/null
    set is_overriden "true"
    set -fx AWS_ACCESS_KEY_ID (echo $credentials | cut -d'|' -f 2)
    set -fx AWS_SECRET_ACCESS_KEY (echo $credentials | cut -d'|' -f 3)
    set -fx AWS_SESSION_TOKEN (echo $credentials | cut -d'|' -f 4)
  else
    set -fx AWS_PROFILE $credentials
  end

  set AWS_REGION (aws configure get region; or echo "eu-west-1")
  set AWS_DEV (aws configure get dev)
  if [ -n "$is_overriden" ]
    set account_info (aws sts get-caller-identity); or exit 2
    set AWS_ACCOUNT (echo "$account_info" | jq -r ".Account")
    set AWS_ROLE (echo "$account_info" | jq -r '.Arn')
  else
    set AWS_ACCOUNT (get_or_set_aws_config aws_account_id "aws sts get-caller-identity --query Account --output text"); or exit 2
  end

  echo "$is_overriden" > $response_file
  echo "$AWS_REGION" >> $response_file
  echo "$AWS_ACCOUNT" >> $response_file
  echo "$AWS_DEV" >> $response_file
  echo "$AWS_ROLE" >> $response_file
  echo "$AWS_PRETTY_NAME" >> $response_file
end

function __baspar_indicator_async_cb_aws -a response_file
  set async_response (cat $response_file)

  set is_overriden $async_response[1]
  set -gx AWS_REGION $async_response[2]
  set -gx AWS_ACCOUNT_ID $async_response[3]
  set AWS_DEV $async_response[4]
  set AWS_ROLE $async_response[5]
  set AWS_PRETTY_NAME $async_response[6]

  if [ -n "$AWS_DEV" ]
    set -gx DEV_AWS_ACCOUNT $AWS_ACCOUNT_ID
  else
    set -e DEV_AWS_ACCOUNT
  end

  set AWS_PRETTY_ROLE (echo $AWS_ROLE | sed 's#^.*:assumed-role/\(.*\)/[^/]*$#\1#g')

  if [ -n "$is_overriden" ]
    if set -q __baspar_no_abbr
      __baspar_indicator_end_override_aws "$AWS_PRETTY_NAME ▒ $AWS_PRETTY_ROLE"
    else
      __baspar_indicator_end_override_aws "$AWS_ACCOUNT_ID ▒ $AWS_PRETTY_ROLE"
    end
  end
end

function __baspar_indicator_test
  __baspar_indicator_test_
  set -e __baspar_transient_prompt
  commandline -f repaint
end

function __baspar_indicator_test_
  read --prompt-str "Input Account ID or Role> " identity; or return
  if string match -r '^arn:aws:iam::(\d{12})?:role/[\w+=,.@-]{1,128}$' $identity > /dev/null
    set credentials (aws sts assume-role --role-arn $identity --role-session-name "test" | jq '.Credentials'); or return
    echo "$credentials" \
      | jq -r '[.AccessKeyId,.SecretAccessKey,.SessionToken] | join(" ")' \
      | read -gx AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN
  else if string match -r '\d{12}' $identity > /dev/null
    set roles (isengardcli cat $identity --output json | jq -r '.IsengardIAMRoles | keys | join("|")'); or return
    set role (echo "$roles" | tr '|' '\n' | fzf --reverse --height 10 --prompt "Pick role for $identity> "); or return
    isengardcli creds --role $role $identity --json \
      | jq -r '[.AccessKeyId,.SecretAccessKey,.SessionToken] | join(" ")' \
      | read -gx AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN
  end
end

setup_indicator aws " " \
  __baspar_indicator_pre_async_aws \
  __baspar_indicator_async_aws \
  __baspar_indicator_async_cb_aws \
  __baspar_indicator_list_aws \
  __baspar_indicator_test

if status is-interactive
  function __baspar_indicator_override_aws --on-variable AWS_ACCESS_KEY_ID --on-variable AWS_SECRET_ACCESS_KEY --on-variable AWS_SESSION_TOKEN
    if [ -n "$AWS_ACCESS_KEY_ID" ] && [ -n "$AWS_SECRET_ACCESS_KEY" ] && [ -n "$AWS_SESSION_TOKEN" ]
      __baspar_indicator_start_override_aws "|$AWS_ACCESS_KEY_ID|$AWS_SECRET_ACCESS_KEY|$AWS_SESSION_TOKEN|"
    end
  end
end

# function assume_role -a role_arn
#   if [ -z "$role_arn" ]
#     echo "Reading role from STDIN"
#     read credentials
#   else
#     set credentials (aws sts assume-role --role-arn $role_arn --role-session-name "mde" | jq '.Credentials')
#   end
#
#   echo "$credentials" \
#     | jq -r '[.AccessKeyId,.SecretAccessKey,.SessionToken] | join(" ")' \
#     | read -gx AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN
# end

function get_or_set_aws_config -a key -a cmd
  set config_file "$HOME/.mde_aws_config.json"
  [ -f "$config_file" ] || echo "{}" > "$config_file"

  set out (jq -r --exit-status ".[\"$AWS_PROFILE\"][\"$key\"]" "$config_file")
  if [ $status -ne 0 ]
    set out (eval $cmd); or return 1
    set config (cat "$config_file")
    echo "$config" | jq ".[\"$AWS_PROFILE\"][\"$key\"] = \"$out\"" > "$config_file"
  end

  echo $out
end

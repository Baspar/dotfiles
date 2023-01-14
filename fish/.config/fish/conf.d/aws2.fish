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

function assume_role -a role_arn
  aws sts assume-role --role-arn $role_arn --role-session-name "mde" \
    | jq -r '.Credentials | [.AccessKeyId,.SecretAccessKey,.SessionToken] | join(" ")' \
    | read -gx AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN
end

#!/usr/bin/env bash
shopt -s extglob; # Enable complex pattern match

usage() {
    local exit_code="${1:-0}"
    local error_msg="$2"

    if [ "$exit_code" -ne 0 ] && [ -n "$error_msg" ]; then
        echo "$error_msg" >&2
    fi

    echo "Usage:"
    echo ""
    echo "log-insight.sh [--stack stack_name] [--region region] [--help]"
    echo " --stack|-s   : AWS CFN stack name (Optional: Will prompt selection if unspecified)"
    echo " --region|-r  : AWS region (Default: \$AWS_REGION or profile region)"
    echo ""
    echo " --help|-h    : Display this help"

    exit "$exit_code"
}

stack=""
AWS_REGION=${AWS_REGION:-$(aws configure get region)}

while (($#)); do
    case "$1" in
        --stack?(=*)|-s?(=*))
            stack=$(echo "$1" | cut -s -d= -f2-)
            ! [ "$stack" ] && shift && stack="$1"
            ;;
        --region?(=*)|-r?(=*))
            AWS_REGION=$(echo "$1" | cut -s -d= -f2-)
            ! [ "$AWS_REGION" ] && shift && AWS_REGION="$1"
            ;;
        -h|--help)
            usage
            ;;
        *)
            usage 5 "Unknown flag or argument: '$1'"
            ;;
    esac
    shift
done

[ "$stack" ] || {
    echo "Fetching CloudFormation stacks..."
    stack=$(aws cloudformation describe-stacks \
        --query 'Stacks[*].StackName' \
        --output text | tr '\t' '\n' | fzf --reverse --height=10 --prompt="Select a Stack > " \
        ) || {
        echo "No stack selected"
        exit 1
    }
}
echo "Using stack '$stack'"

echo "Fetching Log Groups for $stack..."
log_groups=$(aws cloudformation list-stack-resources \
    --stack-name "$stack" \
    --query 'StackResourceSummaries[?ResourceType==`AWS::Logs::LogGroup`].[PhysicalResourceId]' \
    --output text | fzf --reverse --height=10 -m --prompt="Select Log Groups (Tab to multi-select) > " \
    ) || {
    echo "No log groups selected"
    exit 1
}

encoded_log_groups=""
while read -r log_group; do
    encoded_log_group=$(echo "$log_group" | sed 's|/|*2f|g')
    encoded_log_groups="${encoded_log_groups}~'${encoded_log_group}"
done <<< "$log_groups"

URL="https://${AWS_REGION}.console.aws.amazon.com/cloudwatch/home?region=${AWS_REGION}#logsV2:logs-insights\$3FqueryDetail\$3D"
URL+="~(end~0~start~-3600~timeType~'RELATIVE~unit~'seconds~editorString~'fields*20*40timestamp*2c*20level*2c*20coalesce*28message*2c*20*40message*29*2c*20error*0a*7c*20sort*20*40timestamp*20asc*0a*7c*20limit*201000~isLiveTail~false~source~(${encoded_log_groups}))"

echo ""
echo "CloudWatch Logs Insights URL:"
echo "$URL"
printf '\033]52;c;%s\a' "$(echo "$URL" | base64 | tr -d '\n')"
echo "Copied into clipboard"

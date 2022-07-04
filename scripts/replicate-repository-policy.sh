#!/bin/bash -e

repository_policy=$(mktemp)

if [[ -n "${ROLE_TO_ASSUME}" ]]; then
  export $(printf "AWS_ACCESS_KEY_ID=%s AWS_SECRET_ACCESS_KEY=%s AWS_SESSION_TOKEN=%s" \
  $(aws sts assume-role \
  --role-arn "${ROLE_TO_ASSUME}" \
  --role-session-name "terraform-aws-ecr" \
  --query "Credentials.[AccessKeyId,SecretAccessKey,SessionToken]" \
  --output text))
fi

printf "%s/%s - Retrieve repository policy from source repository.\n" "${REPOSITORY}" "${CURRENT_REGION}"
aws ecr \
  get-repository-policy \
  --repository-name "${REPOSITORY}" \
  --region "${CURRENT_REGION}" \
  > "${repository_policy}"

should_be_replicated=$(aws ecr list-images --repository-name "${REPOSITORY}" --region "${CURRENT_REGION}" | jq -r ".imageIds | length")

if [ "${should_be_replicated}" -gt 0 ]; then
  aws ecr \
    describe-repositories \
    --repository-names "${REPOSITORY}" \
    --region "${REGION}" \
    > /dev/null 2>&1
  printf "%s/%s - Repository exists in region.\n" "${REPOSITORY}" "${REGION}"
  printf "%s/%s - Applying repository policy.\n" "${REPOSITORY}" "${REGION}"
  aws ecr \
    set-repository-policy \
    --repository-name "${REPOSITORY}" \
    --region "${REGION}" \
    --cli-input-json "file://${repository_policy}" \
    > /dev/null 2>&1
  printf "%s/%s - Policy applied.\n" "${REPOSITORY}" "${REGION}"
else
  printf "%s/%s - Repository is empty and not replicated. Skipping.\n" "${REPOSITORY}" "${REGION}"
fi

rm -f "${repository_policy}"

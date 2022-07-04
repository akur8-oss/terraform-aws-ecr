#!/bin/bash -e

lifecycle_policy=$(mktemp)

printf "%s/%s - Retrieve lifecycle policy from source repository.\n" "${REPOSITORY}" "${CURRENT_REGION}"

if [[ -n "${ROLE_TO_ASSUME}" ]]; then
  export $(printf "AWS_ACCESS_KEY_ID=%s AWS_SECRET_ACCESS_KEY=%s AWS_SESSION_TOKEN=%s" \
  $(aws sts assume-role \
  --role-arn "${ROLE_TO_ASSUME}" \
  --role-session-name "terraform-aws-ecr" \
  --query "Credentials.[AccessKeyId,SecretAccessKey,SessionToken]" \
  --output text))
fi

aws ecr \
  get-lifecycle-policy \
  --repository-name "${REPOSITORY}" \
  --region "${CURRENT_REGION}" \
  | jq 'del(.lastEvaluatedAt)' \
  > "${lifecycle_policy}"

should_be_replicated=$(aws ecr list-images --repository-name "${REPOSITORY}" --region "${CURRENT_REGION}" | jq -r ".imageIds | length")

if [ "${should_be_replicated}" -gt 0 ]; then
  aws ecr \
    describe-repositories \
    --repository-names "${REPOSITORY}" \
    --region "${REGION}" \
    >/dev/null 2>&1
  printf "%s/%s - Repository exists in region.\n" "${REPOSITORY}" "${REGION}"
  printf "%s/%s - Applying lifecycle policy.\n" "${REPOSITORY}" "${REGION}"
  aws ecr \
    put-lifecycle-policy \
    --repository-name "${REPOSITORY}" \
    --region "${REGION}" \
    --cli-input-json "file://${lifecycle_policy}" \
    >/dev/null 2>&1
  printf "%s/%s - Policy applied.\n" "${REPOSITORY}" "${REGION}"
else
  printf "%s/%s - Repository is empty in %s and not replicated. Skipping.\n" "${REPOSITORY}" "${REGION}" "${CURRENT_REGION}"
fi

rm -f "${lifecycle_policy}"

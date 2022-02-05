#!/bin/bash -e

lifecycle_policy=$(mktemp)

printf "%s/%s - Retrieve lifecycle policy from source repository.\n" "${REPOSITORY}" "${CURRENT_REGION}"

aws ecr \
  get-lifecycle-policy \
  --repository-name "${REPOSITORY}" \
  | jq 'del(.lastEvaluatedAt)' \
  > "${lifecycle_policy}"

{
  aws ecr \
    describe-repositories \
    --repository-names "${REPOSITORY}" \
    --region "${CURRENT_REGION}" \
    > /dev/null 2>&1
  printf "%s/%s - Repository exist in region.\n" "${REPOSITORY}" "${REGION}"
  printf "%s/%s - Applying lifecycle policy.\n" "${REPOSITORY}" "${REGION}"
} && {
  aws ecr \
    put-lifecycle-policy \
    --repository-name "${REPOSITORY}" \
    --region "${REGION}" \
    --cli-input-json "file://${lifecycle_policy}" \
    > /dev/null 2>&1
  printf "%s/%s - Policy applied.\n" "${REPOSITORY}" "${REGION}"
}

rm -f "${lifecycle_policy}"

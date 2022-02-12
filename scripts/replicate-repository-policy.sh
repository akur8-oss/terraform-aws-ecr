#!/bin/bash -e

repository_policy=$(mktemp)

printf "%s/%s - Retrieve repository policy from source repository.\n" "${REPOSITORY}" "${CURRENT_REGION}"
aws ecr \
  get-repository-policy \
  --repository-name "${REPOSITORY}" \
  --region "${CURRENT_REGION}" \
  > "${repository_policy}"

{
  aws ecr \
    describe-repositories \
    --repository-names "${REPOSITORY}" \
    --region "${REGION}" \
    > /dev/null 2>&1
  printf "%s/%s - Repository exist in region.\n" "${REPOSITORY}" "${REGION}"
  printf "%s/%s - Applying repository policy.\n" "${REPOSITORY}" "${REGION}"
} && {
  aws ecr \
    set-repository-policy \
    --repository-name "${REPOSITORY}" \
    --region "${REGION}" \
    --cli-input-json "file://${repository_policy}" \
    > /dev/null 2>&1
  printf "%s/%s - Policy applied.\n" "${REPOSITORY}" "${REGION}"
}

rm -f "${repository_policy}"

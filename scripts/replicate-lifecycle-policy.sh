#!/bin/bash -e

lifecycle_policy=$(mktemp)

printf "%s/%s - Retrieve lifecycle policy from source repository.\n" "${REPOSITORY}" "${CURRENT_REGION}"

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

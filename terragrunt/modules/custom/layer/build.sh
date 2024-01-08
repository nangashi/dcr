#!/usr/bin/env bash
set -eu -o pipefail

# echo to stderr
eecho() { echo "$@" 1>&2; }

PYTHON_VERSION=$1
SOURCE_PATH=$2

# if [[ -f ${SOURCE_PATH}/requirements.txt ]]; then
#   eecho "[ERROR] requirements file '${REQUIREMENTS_FILE}' not found."
#   exit 1
# fi

DEST_DIR=$(mktemp -d)
mkdir ${DEST_DIR}/python
cp -r ${SOURCE_PATH}/* ${DEST_DIR}/python/

(
  cd "${DEST_DIR}"

  # Run pip install command inside the official python docker image
  requirements_file=./python/requirements.txt
  if [[ -f "${requirements_file}" ]]; then
    docker run --rm -u "${UID}:${UID}" -v "${DEST_DIR}:/work" -w /work "public.ecr.aws/sam/build-${PYTHON_VERSION}:latest" pip install -r "${requirements_file}" -t ./python >&2
  fi

  # Remove unneeded files
  find python \( -name '__pycache__' -o -name '*.dist-info' \) -type d -print0 | xargs -0 rm -rf
  rm -rf python/bin

  # Return JSON for Terraform
  jq -n --arg path "${DEST_DIR}" '{"path":$path}'
)

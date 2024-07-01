#!/usr/bin/env bash

openapi-generator generate \
  -i ./pkg/openapi/openapi.yaml \
  --output docs \
  -g html2 \
  --git-user-id barrygear \
  --git-repo-id jabali-sdk

openapi-generator generate \
  -i ./pkg/openapi/openapi.yaml \
  -g dynamic-html \
  --output html_docs \
  --git-user-id barrygear \
  --git-repo-id jabali-sdk

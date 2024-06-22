#!/usr/bin/env bash

openapi-generator generate \
  -i ./pkg/openapi/openapi.yaml \
  --output generated/client \
  -g go \
  --additional-properties packageName=jabali_sdk,packageVersion=0.0.1,useTags=true \
  --git-user-id barrygear \
  --git-repo-id jabali-sdk

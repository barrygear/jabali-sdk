#!/usr/bin/env bash

openapi-generator generate \
  -i ../jabali-sdk/pkg/openapi/openapi.yaml \
  -g go-gin-server \
  --output server \
  --additional-properties packageName=jabali_sdk,packageVersion=0.0.1,useTags=true,outputAsLibrary=true,sourceFolder=openapi \
  --git-user-id barrygear \
  --git-repo-id jabali
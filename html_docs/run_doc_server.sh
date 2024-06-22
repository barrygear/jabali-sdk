#!/usr/bin/env bash
if [[ ! -f "package.json" ]]; then 
    npm init -y        
fi

npm install express
node main.js

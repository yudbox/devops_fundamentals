#!/bin/bash

npm run lint
npm audit
npm run e2e


./build-client.sh

scp -i ~/.ssh/id_rsa -r ./dist/* susha@127.0.0.1:/var/www/html/

#!/usr/bin/env bash

# скопировал часть из build-client скрипта. Хотя можно было продолжить в билд скрипте

export ENV_CONFIGURATION=production

PROJECT_FOLDER=shop-angular-cloudfront
BUILD_ZIP_FILE=dist/client-app.zip


sudo apt-get update
sudo apt-get install -y git
git --version

cd ~


if [[ -f "$PWD/$PROJECT_FOLDER/package.json" ]]
then
        echo "Project shop-angular-cloudfront was cloned before"
        cd $PROJECT_FOLDER
    else
        echo "Project shop-angular-cloudfront nor found. Start cloning..."
        git clone https://github.com/EPAM-JS-Competency-center/shop-angular-cloudfront.git
        cd $PROJECT_FOLDER
fi

npm install

npm run lint

if [[ $? != 0 ]]; then
    echo
    echo "linting not passed"
    exit 1
fi

npm run test

if [[ $? != 0 ]]; then
    echo
    echo "testing not passed"
    exit 1
fi


npm run build --configuration=$ENV_CONFIGURATION
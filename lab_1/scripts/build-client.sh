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

npm run build --configuration=$ENV_CONFIGURATION

if [[ -f $BUILD_ZIP_FILE ]]
    then rm $BUILD_ZIP_FILE
    echo "$BUILD_ZIP_FILE was deleted"
    else
    echo "$BUILD_ZIP_FILE not exist"
fi

zip -r dist/client-app.zip dist/



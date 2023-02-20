#!/usr/bin/env bash
#
#   to run it use: 
#    ./.github/workflows/clean_project.sh 
#
# Script cleans current flutter project:
#  - flutter clean
#  - removes pubspec.lock, 
#  - flutter pub get

flutterPubUpgrade() {
    echo -e "\nUpgrading packages..."
    flutter pub upgrade
}

echo -e "\nCleaning project..."
flutter clean

echo -e "\nDeleting unnecessary files in \"$PWD\""
find . -name "pubspec.lock" -type f -exec rm -vf {} \;

echo -e "\nInstalling packages..."
flutter pub get

# flutter pub outdated
# echo
# while true; do
#     read -p 'Would you like to upgrade resolvable dependencies: ' answer
#     answer=$(echo "$answer" | tr '[:upper:]' '[:lower:]')
#     case ${answer:0:1} in
#         y|yes )
#             flutterPubUpgrade;
#             break;;
#         n|no )
#             echo -e "\nexit..."
#             exit;;
#         * ) echo "Please answer yes or no.";;
#     esac
# done

echo -e "\nall done."

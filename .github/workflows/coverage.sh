#!/bin/bash
NC='\033[0m'
RED='\033[0;31m'          # Red
GREEN='\033[0;32m'        # Green

coverageFactor=30 # minimum percentage of unit tests coverage for each file
coverageResults=()
coverageExitStatus=0

flutter test --coverage

# Get version of GNU tool
compare() {
    local value1="$1" operator="$2" value2="$3"
    awk -vv1="$value1" -vv2="$value2" 'BEGIN {
        split(v1, a, /\./); split(v2, b, /\./);
        if (a[1] == b[1]) {
            exit (a[2] '$operator' b[2]) ? 0 : 1
        }
        else {
            exit (a[1] '$operator' b[1]) ? 0 : 1
        }
    }'
}


path="./coverage/lcov.info"
while IFS= read -r line
do
    if [[ $line == 'SF:'* ]]; then
        currentFile=$(sed -r 's/^SF:(.+)/\1/' <<< $line)
        currentCov=0
    fi
    if [[ $line == 'LF:'* ]]; then
        currentLF=$(sed -r 's/^LF:([0-9]+)/\1/' <<< $line)
    fi
    if [[ $line == 'LH:'* ]]; then
        currentLH=$(sed -r 's/^LH:([0-9]+)/\1/' <<< $line)
    fi
    if [[ $line == 'end_of_record' ]]; then
        currentCov=$(printf %.2f\\n "$((10000 *   $currentLH/$currentLF))e-2")
        if compare $currentCov '>' $coverageFactor; then
            message=$(echo -e "${GREEN}$currentCov\t|\t$currentFile${NC}")
            echo "::notice file=$currentFile,title=Good coverage level::$currentCov%"
        else
            message=$(echo -e "${RED}$currentCov\t|\t$currentFile${NC}")
            echo "::error file=$currentFile,title=Low coverage level::$currentCov% < $coverageFactor%"
            ((coverageExitStatus=coverageExitStatus+1))
        fi
        coverageResults+=( $message )
        echo $message
    fi
done < "$path"
# echo "results=$coverageResults" >> $GITHUB_OUTPUT
if [[ !coverageExitStatus != 0 ]]; then 
    echo "#### 🔴 Some files are not enough covered by unit tests!" >> $GITHUB_STEP_SUMMARY
    echo 'Please check details on your local machine using commands:' >> $GITHUB_STEP_SUMMARY
    echo '```' >> $GITHUB_STEP_SUMMARY
    echo '  flutter test --coverage' >> $GITHUB_STEP_SUMMARY
    echo '  genhtml coverage/lcov.info -o coverage/html' >> $GITHUB_STEP_SUMMARY
    echo '  open coverage/html/index.html' >> $GITHUB_STEP_SUMMARY
    echo '```' >> $GITHUB_STEP_SUMMARY
fi
exit $coverageExitStatus

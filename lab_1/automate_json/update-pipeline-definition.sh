#!/usr/bin/env bash

checkJQ() {
  # jq test
  type jq > /dev/null 2>&1
  exitCode=$?

  if [ "$exitCode" != 0 ]; then
    printf "  ${red}'jq' not found! (json parser)\n${end}"
    printf "    MacOS Installation:  https://jira.amway.com:8444/display/CLOUD/Configure+PowerShell+for+AWS+Automation#ConfigurePowerShellforAWSAutomation-MacOSSetupforBashScript\n"
    printf "    Ubuntu Installation: sudo apt install jq\n"
    printf "    Redhat Installation: sudo yum install jq\n"
    echo "INSIDE"
    jqDependency=0
  else
    if [[ "$DEBUG" == 1 ]]; then
      printf "  ${grn}'jq' found!\n${end}"
    fi
  fi


  if [[ "$jqDependency" == 0 ]]; then
    printf "${red}Missing 'jq' dependency, exiting.\n${end}"
    exit 1
  fi
}

# perform checks:
checkJQ


UPDATED_PIPELINE_FILE=pipeline-$(date +'%Y-%m-%d-%H-%M-%S').json

pathToJSON="./pipeline.json"
configuration=production
owner=$(git config --get user.name)
branchName=main
pll=false

    # check if json file path is correct
    if [[ !$1 && $1 =~ [A-Za-z.\/]+.json && -f $1 ]]; then
            pathToJSON=$1
        else
            echo "Path to JSON file is uncorrect. Exit programm"
            exit 1
    fi

    while [ "${1:-}" != "" ]; do
        case "$1" in
        "-c" | "--configuration")
            shift
            configuration=$1
            ;;
        "-o" | "--owner")
            shift
            owner=$1

            ;;
        "-b" | "--branch")
            shift
            branch=$1
            ;;
        "-pll" | "--poll-for-source-changes")
            shift
            pll=$1
            ;;
        esac
        shift
    done

# if name has spaces jq cannot update json, raplace spaces to '_'
owner="${owner// /_}"

# echo $branchName
# echo $configuration
# echo $owner
# echo $pll



cat $pathToJSON | 
jq '.' |
jq 'del(.metadata)' |
jq '.pipeline.version += 1' |
jq --arg branchName $branchName '.pipeline.stages[0].actions[0].configuration.Branch = $branchName' |
jq --arg owner $owner '.pipeline.stages[0].actions[0].configuration.Owner = $owner' |
jq --arg pll $pll '.pipeline.stages[0].actions[0].configuration.PollForSourceChanges = $pll' |
tee $UPDATED_PIPELINE_FILE
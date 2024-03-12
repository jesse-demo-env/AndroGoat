#!/bin/bash

red=$'\e[1;31m'
grn=$'\e[1;32m'
yel=$'\e[1;33m'
blu=$'\e[1;34m'
mag=$'\e[1;35m'
cyn=$'\e[1;36m'
end=$'\e[0m'

file=demorepos.txt
lines=`cat ${file}`
workdir=$PWD

function prereqs(){

# check for workdir and clean
if [ -d "$workdir" ]
then 
    rm -rf $workdir && mkdir $workdir
else
    mkdir $workdir
fi

if [ -z "${GITHUB_TOKEN}" ]
then
    echo "${red}Please set your Github Token as an environment variable using the following command export GITHUB_TOKEN=myghtoken ${end}"
    exit
fi

if [ -z "${GITHUB_USER}" ]
then
    echo "${red}Please set your Github username as an environment variable using the following command export GITHUB_USER=myghusername ${end}"
    exit
fi

if [ -z "${GITHUB_ORG}" ]
then
    echo "${red}Please set your desired Github organization to populate as an environment variable using the following command export GITHUB_ORG=myghorgname ${end}"
    exit
fi


}

function setupgh(){

# loop through text file
for line in $lines; do
    cd $workdir
    echo -e "${cyn}Cloning ${line} ${end}"
    git clone --depth 1 $line
    repo=$(basename -s .git $line)
    echo -e "${cyn}Repo will be called $repo ${end}"
    cd $workdir/$repo
    currentbranch=$(git branch --show-current)
    echo -e "${cyn}Cloned ${line} into $workdir/$repo ${end}"
    repourl=https://github.com/${GITHUB_ORG}/${repo}.git

    # delete .github folder if it exists
    if [ -d "$workdir/$repo/.github" ]
    then
        git rm -rf $workdir/$repo/.github
        git commit -m "removed .github folder" -a 
        echo -e "${cyn}Deleted .github folder ${line} ${end}"
    fi
    createghrepo
    git checkout -b main $currentbranch
    git remote set-url origin $repourl
    git push --set-upstream origin main
    
done

}

function createghrepo(){
### Create Github Repo
curl -X POST -H 'Accept: application/vnd.github.v3+json' -u $GITHUB_USER:$GITHUB_TOKEN\
  https://api.github.com/orgs/${GITHUB_ORG}/repos \
  -d '{"name":"'$repo'"}'
echo -e "${yel}Created repo at $repourl${end}"

prereqs
setupgh

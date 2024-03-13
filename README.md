# massreposetup

## Usage
- Create a new github organization
- Set the following environment variables
```shell
export GITHUB_USER=my-github-username
export GITHUB_TOKEN=my-github-token
export GITHUB_ORG=my-github-organization
```
Download and run the script
```shell
git clone https://github.com/samq-ws/massreposetup.git && cd massreposetup && chmod +x setup.sh
./setup.sh
```

For ease of use, a docker container is recommended unless git is already installed on your machine
```shell
docker run --name test -i -d ubuntu:latest
docker exec -it test bash

apt update && export DEBIAN_FRONTEND=noninteractive && apt install -y git curl nano unzip zip jq

git config --global credential.helper 'cache --timeout=3600'
git config --global user.email "your-email"
git config --global user.name "your-name"
```
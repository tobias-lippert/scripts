#!/usr/bin/env bash

# This script still assumes it's running on wsl that's why we neither install kubectl nor docker because it's
# provided by Docker Desktop for Windows
sudo apt-get update && sudo apt upgrade -y
# TODO for the p10k theme install Meslo LGS NF font
# install zsh and make it the default shell
sudo apt install -y zsh
chsh -s $(which zsh)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
sudo cp .zshrc ~/.zshrc
sudo cp .p10k.zsh ~/.p10k.zsh
sudo apt install -y unzip
# install helm
 sudo curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 && sudo chmod 700 get_helm.sh && sudo ./get_helm.sh
 # install azure cli
 curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

 # install aws cli
sudo curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo unzip awscliv2.zip
sudo ./aws/install
 # install jq
sudo apt install -y jq

 # install terraform
wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform

# notary, required for the azure container registry to work using azure cli
sudo apt install -y notary

# kubectl autocompletion
source <(kubectl completion zsh)
kubectl completion zsh > "${fpath[1]}/_kubectl"

# helm autocompletion
source <(helm completion zsh)
helm completion zsh > "${fpath[1]}/_helm"

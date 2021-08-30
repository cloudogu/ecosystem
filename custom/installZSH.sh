CUSTOM_ZSH_PROFILE="/vagrant/custom/.zshrc"
CUSTOM_POWERLEVEL_PROFILE="/vagrant/custom/.p10k.zsh"
CUSTOM_PET_SNIPPETS="/vagrant/custom/snippet.toml"
CUSTOM_PET_CONFIG="/vagrant/custom/petConfig.toml"

VAGRANT_HOME="/home/vagrant"
ROOT_HOME="/root"

aptInstl() {
  DEBIAN_FRONTEND=noninteractive apt-get install -qq -y $1 > /dev/null
}

install_zsh() {
  # Install oh-my-zsh
  if [[ ! -d "${VAGRANT_HOME}/.oh-my-zsh" ]]; then 
    echo "Installing 'oh-my-zsh' for the vagrant user..."
    aptInstl "zsh"
    su -l vagrant -s "/bin/sh" \
      -c "curl -fsSO https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh; chmod 755 install.sh; ./install.sh --unattended"
  fi
  
  # Install enhanpowerlevel10kcd
  if [[ ! -d "${VAGRANT_HOME}/.oh-my-zsh/custom/themes/powerlevel10k" ]]; then 
    echo "Installing 'powerlevel10k' for the vagrant user..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${VAGRANT_HOME}"/.oh-my-zsh/custom/themes/powerlevel10k
  fi
  
  # Install enhancd
  if [[ ! -d "${VAGRANT_HOME}/.oh-my-zsh/plugins/enhancd" ]]; then 
    echo "Installing 'enhancd' for the vagrant user..."
    git clone https://github.com/b4b4r07/enhancd "${VAGRANT_HOME}"/.oh-my-zsh/plugins/enhancd
  fi
  
  # Install zsh-autosuggestions
  if [[ ! -d "${VAGRANT_HOME}/.oh-my-zsh/plugins/zsh-autosuggestions" ]]; then 
    echo "Installing 'zsh-autosuggestions' for the vagrant user..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "${VAGRANT_HOME}"/.oh-my-zsh/plugins/zsh-autosuggestions
  fi
  
  # Install zsh-completions
  if [[ ! -d "${VAGRANT_HOME}/.oh-my-zsh/plugins/zsh-completions" ]]; then 
    echo "Installing 'zsh-completions' for the vagrant user..."
    git clone https://github.com/zsh-users/zsh-completions "${VAGRANT_HOME}"/.oh-my-zsh/plugins/zsh-completions
  fi
  
  # Install syntax-highlighting
  if [[ ! -d "${VAGRANT_HOME}/.oh-my-zsh/plugins/zsh-syntax-highlighting" ]]; then 
    echo "Installing 'zsh-syntax-highlighting' for the vagrant user..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${VAGRANT_HOME}"/.oh-my-zsh/plugins/zsh-syntax-highlighting
  fi
  
  # Set shell
  chsh -s /bin/zsh vagrant
  
  # Copy zshrc...
  echo "Copy .zshrc to vagrant user..."
  cp "${CUSTOM_ZSH_PROFILE}" "${VAGRANT_HOME}"/.zshrc
  cp "${CUSTOM_POWERLEVEL_PROFILE}" "${VAGRANT_HOME}"/.p10k.zsh
  
  # Copy snippets
  echo "Copy snippets to vagrant user..."
  su -l vagrant -s "/bin/sh" -c "mkdir -p ${VAGRANT_HOME}/.config/pet"
  
  su -l vagrant -s "/bin/sh" -c "cp ${CUSTOM_PET_CONFIG} ${VAGRANT_HOME}/.config/pet/config.toml"
  if [[ -f "${CUSTOM_PET_SNIPPETS}" ]]; then
    su -l vagrant -s "/bin/sh" -c "cp ${CUSTOM_PET_SNIPPETS} ${VAGRANT_HOME}/.config/pet/snippet.toml"
  fi
}

install_zsh_root() {
  # Install oh-my-zsh
  if [[ ! -d "${ROOT_HOME}/.oh-my-zsh" ]]; then 
    echo "Installing Oh-My-Zsh for the root user..."
    aptInstl "zsh"
    sudo su -l root -s "/bin/sh" \
      -c "curl -fsSO https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh; chmod 755 install.sh; ./install.sh --unattended"
  fi
  
  # Install powerlevel10k
  if [[ ! -d "${ROOT_HOME}/.oh-my-zsh/custom/themes/powerlevel10k" ]]; then 
    echo "Installing 'powerlevel10k' for the root user..."
    sudo git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ROOT_HOME}"/.oh-my-zsh/custom/themes/powerlevel10k
  fi
  
  # Install enhancd
  if [[ ! -d "${ROOT_HOME}/.oh-my-zsh/plugins/enhancd" ]]; then 
    echo "Installing 'enhancd' for the root user..."
    git clone https://github.com/b4b4r07/enhancd "${ROOT_HOME}"/.oh-my-zsh/plugins/enhancd
  fi
  
  # Install zsh-autosuggestions
  if [[ ! -d "${ROOT_HOME}/.oh-my-zsh/plugins/zsh-autosuggestions" ]]; then 
    echo "Installing 'zsh-autosuggestions' for the root user..."
    sudo git clone https://github.com/zsh-users/zsh-autosuggestions "${ROOT_HOME}"/.oh-my-zsh/plugins/zsh-autosuggestions
  fi
  
  # Install zsh-completions
  if [[ ! -d "${ROOT_HOME}/.oh-my-zsh/plugins/zsh-completions" ]]; then 
    echo "Installing 'zsh-completions' for the root user..."
    git clone https://github.com/zsh-users/zsh-completions "${ROOT_HOME}"/.oh-my-zsh/plugins/zsh-completions
  fi
  
  # Install syntax-highlighting
  if [[ ! -d "${ROOT_HOME}/.oh-my-zsh/plugins/zsh-syntax-highlighting" ]]; then 
    echo "Installing 'zsh-syntax-highlighting' for the root user..."
    sudo git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ROOT_HOME}"/.oh-my-zsh/plugins/zsh-syntax-highlighting
  fi
  
  # Set shell
  sudo chsh -s /bin/zsh root
  
  # Copy zshrc...
  echo "Copy .zshrc to root user..."
  sudo cp "${CUSTOM_ZSH_PROFILE}" "${ROOT_HOME}"/.zshrc
  sudo cp "${CUSTOM_POWERLEVEL_PROFILE}" "${ROOT_HOME}"/.p10k.zsh
  
  # Copy snippets
  echo "Copy snippets to root user..."
  sudo mkdir -p "${ROOT_HOME}"/.config/pet
  
  sudo cp "${CUSTOM_PET_CONFIG}" "${ROOT_HOME}/.config/pet/config.toml"
  if [[ -f "${CUSTOM_PET_SNIPPETS}" ]]; then
    sudo cp "${CUSTOM_PET_SNIPPETS}" "${ROOT_HOME}"/.config/pet/snippet.toml
  fi
}

install_miscellaneous() {
  sudo rm pet_0.3.6_linux_amd64.deb -f
  wget -q https://github.com/knqyf263/pet/releases/download/v0.3.6/pet_0.3.6_linux_amd64.deb > /dev/null
  dpkg -i pet_0.3.6_linux_amd64.deb > /dev/null

  apt-get update > /dev/null
  apt-get upgrade > /dev/null
  for i in curl git fzy fzf xsel; do
    aptInstl "$i"
  done
}

main() {
  install_miscellaneous
  install_zsh
  install_zsh_root
}
main

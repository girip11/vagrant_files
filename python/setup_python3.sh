#!/bin/bash

function install_pyenv_prereq() {
  echo "Installing prerequisites for pyenv"
  local deps=(gcc make zlib1g-dev libbz2-dev libreadline-dev
    libsqlite3-dev libssl-dev ant)
  apt-get update
  apt-get install -y "${deps[@]}"
}

function install_pyenv() {
  echo "Installing pyenv"
  curl https://pyenv.run | bash

  {
    cat << "EOF"
export PATH="$HOME/.pyenv/bin:$HOME/.local/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
EOF
  } >> ~/.pyenv_path

  {
    cat << "EOF"
if [[ -f ~/.pyenv_path ]]; then
    . ~/.pyenv_path
fi
EOF
  } >> ~/.bashrc

  # shellcheck source=/dev/null
  source ~/.pyenv_path
  pyenv --version

  echo "Installing python 3.6.8"
  pyenv install 3.6.8 && pyenv global 3.6.8
  python --version
  pip install --upgrade pip

  echo "Installing pipenv"
  pip install pipenv
  pipenv --version

  echo "Installing ipython"
  pip install ipython
  ipython --version
}

user=${1:-vagrant}

if [[ $(whoami) != 'root' ]]; then
  echo "This script should be run as root."
  exit 1
fi

install_pyenv_prereq

export -f install_pyenv
su -c install_pyenv "$user"
unset -f install_pyenv

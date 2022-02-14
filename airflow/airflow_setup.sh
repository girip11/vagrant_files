#!/bin/bash

# Reference https://medium.com/@jacksonbull1987/how-to-install-apache-airflow-6b8a2ae60050
echo "Setting up python and pip"

apt-get update
apt-get install -y python-setuptools
apt install -y python3-pip
pip install --upgrade pip

function install_airflow() {
  echo "Installing airflow as $(whoami)"
  pip install --user apache-airflow
  pip install --user typing_extensions
  echo "Installation complete."
}

function setup_airflow() {
  echo "Setting up airflow"
  export AIRFLOW_HOME=~/airflow
  export PATH="$PATH:/home/vagrant/.local/bin"

  # initialize the database
  airflow db init

  airflow users create --role Admin --username admin \
    --email admin@example.com --firstname admin --lastname admin \
    --password admin

  echo "Setup complete."
}

echo 'export PATH="$PATH:/home/vagrant/.local/bin"' >> /home/vagrant/.bashrc
export -f install_airflow setup_airflow
su vagrant -s /bin/bash -c install_airflow
su vagrant -s /bin/bash -c setup_airflow

echo "Setup complete."

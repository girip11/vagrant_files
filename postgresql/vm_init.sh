#!/bin/bash
# This script should run in the context of the root
# This script installs pgadmin4 and configures the postgresql and pgadmin
# References:
# 1. https://www.itzgeek.com/how-tos/linux/ubuntu-how-tos/how-to-install-postgresql-10-on-ubuntu-18-04-lts.html
# 2. https://www.journaldev.com/26285/install-postgresql-pgadmin4-ubuntu
# 3. https://www.howtoforge.com/how-to-install-postgresql-and-pgadmin4-on-ubuntu-1804-lts/

function install_postgresql() {
  apt install wget ca-certificates
  wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
  sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'
  apt update
  apt install -y postgresql-10 postgresql-contrib-10
}

function configure_postgresql() {
  postgresql_conf_path=$1
  # edit /etc/postgresql/10/main/postgresql.conf
  # listen_addresses = '*'
  postgresql_conf="$postgresql_conf_path/postgresql.conf"

  if [[ -s $postgresql_conf ]]; then
    listen_addresses=$(cat $postgresql_conf | grep 'listen_addresses')

    if [[ ${listen_addresses:0:1} == '#' ]]; then
      uncommented=${listen_addresses:1}
      listen_all_addresses=${uncommented/localhost/*}
      echo "Original string: $listen_addresses, replacement string: $listen_all_addresses"
      sed -i "s/${listen_addresses}/${listen_all_addresses}/" $postgresql_conf
    fi
  else
    echo "$postgresql_conf file doesnot exist"
  fi

  # add below line to /etc/postgresql/10/main/pg_hba.conf
  # host  all  all  0.0.0.0/0 md5
  pg_hba_conf="$postgresql_conf_path/pg_hba.conf"
  pattern="^host[[:space:]]*all[[:space:]]*all[[:space:]]*[[:space:]]*127.0.0.1/32[[:space:]]*md5$"
  search=$(cat $pg_hba_conf | grep -x $pattern)

  if [[ -n $search ]]; then
    replace=${search/127.0.0.1\/32/0.0.0.0\/0}
    echo "Original string: $search, replacement string: $replace"

    # Escape / in IP so that it doesnot create parsing problem with sed expression /
    escaped_search=${search/\//\\\/}
    escaped_replace=${replace/\//\\\/}

    sed -i "s/$escaped_search/$escaped_replace/" $pg_hba_conf
  fi

  systemctl restart postgresql
}

# sets password of postgres user
# Password with $ is not working. Investigate.
function set_postgresql_user_passwd() {
  local user_name=$1
  local user_passwd=$2

  echo "Changing password for $user_name"
  local change_passwd_cmd="alter role $user_name password '$user_passwd'"
  local psql_cmd="psql -c \"$change_passwd_cmd\""
  echo "Executing the postgresql command: $psql_cmd"
  su -c "$psql_cmd" postgres
}

if ! $(systemctl status postgresql | grep 'postgresql.service'); then
  install_postgresql
  set_postgresql_user_passwd 'postgres' 'postgres'
  configure_postgresql '/etc/postgresql/10/main'

  echo "Postgresql was installed successfully"
else
  echo "Postgresql was already installed"
fi

if ! $(command -v pgadmin4); then
  apt update
  apt install -y pgadmin4 pgadmin4-apache2
fi

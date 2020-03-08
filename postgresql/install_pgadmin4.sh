#!/bin/bash

# URL https://192.168.1.10/pgadmin4
# If any error in accessing pgadmin4 site
# look in to the logs at /var/log/apache2/error.log

if ! command -v pgadmin4; then
  apt-get update
  apt-get install -y pgadmin4 pgadmin4-apache2
fi

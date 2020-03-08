# Using the Vagrant VM

* `vagrant up` - creates and provisions the VM. As part of VM provisioning, postgresql is installed.

* `vagrant ssh` - to SSH in to the VM and execute the **install_pgadmin4.sh** and provides the **email and password**

* With pgadmin4 installed, we can load the url `http://ip/pgadmin4` in the browser and create a server pointing the postgresql installed within the VM.

* Create a database for your testing purpose and start writing queries using the query tool provided by pgadmin4.

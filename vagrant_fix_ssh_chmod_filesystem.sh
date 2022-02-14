#!/bin/bash

function stop_vm() {

  if ! vagrant halt "$1"; then
    vagrant halt --force "$1"
  fi
}

function vagrant_up() {
  vm_name="$1"
  vm_ssh_target_dir="$HOME/vagrant_ssh_perm/$vm_name"
  current_dir="$(pwd)"
  vm_ssh_key="$current_dir/.vagrant/machines/$vm_name/virtualbox/private_key"

  echo "Creating and provisioning the VM ${vm_name}"
  vm_up_msg="$(vagrant up "$vm_name" 2>&1)"
  echo "$vm_up_msg"

  if grep -q "The private key to connect to this box via SSH has invalid permissions
set on it" <<< "$vm_up_msg"; then
    echo "Stopping the VM ${vm_name}"
    stop_vm "$vm_name"
    sleep 5

    # copying the SSH key to filesystem with CHMOD permission
    echo "Copying the SSH key to chmod filesystem"
    mkdir -p "$vm_ssh_target_dir"
    cp -f "$vm_ssh_key" "$vm_ssh_target_dir" && rm "$vm_ssh_key"
    sudo chmod 600 "$vm_ssh_target_dir/private_key"
    ln -s "$vm_ssh_target_dir/private_key" "$vm_ssh_key"

    # start the VM again
    echo "Starting the VM ${vm_name}"
    vagrant up "$vm_name"
  fi

}

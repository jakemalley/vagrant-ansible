
#!/usr/bin/env bash

## Install Ansible for provisioning

set -e
set -x

dnf -y update
dnf -y install python3
dnf -y install ansible
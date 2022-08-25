# void-config
Void installer and config setup with dash and ansible

# How to use

On the host machine, some steps have to be done in order to run the playbook.

```bash
# update xbps
xbps-install -u xbps

# install git and ansible
xbps-install -S git ansible
```

Once the repository is cloned, the playbook can be run using:

```bash

    Set the root password using the passwd command.
    Restart the ssh service using systemctl restart sshd.
    Create a keyfile on your local host containing the password for your LUKS root volume via echo -n "your_password" > keyfile.
    Generate a hash for the password to be used on your personal account using mkpasswd --method=sha-512.

At this point we are able to login remotely as root, so we can populate inventory.yml and run site.yml:

--> https://github.com/jsf9k/ansible-arch-install
```
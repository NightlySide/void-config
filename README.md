# void-config
Void installer and config setup with dash and ansible

# How to use

Nothing has to be done on the VM or target machine except booting on a voidlinux ISO.

First, change the variables in the `group_vars` folder in order to match your requirements.

On the host machine, run the following command:

```bash
ansible-playbook -i inventory.yml iso-install.yml
```

Reboot the target machine and it's done!

# TODO

- Add swap partition
- Remove LUKS encryption on either grub or the root partition
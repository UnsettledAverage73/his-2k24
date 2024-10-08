#!/bin/bash

chk_sep_part(){
  [[ -n $(findmnt -kn $@) && -n $(grep $@ /etc/fstab) ]] && echo -e "\t- Seperate partion for $@ exists." || echo -e "\t- Seperate Partion for $@ does not exists."
}

chk_nodev(){
  [ -z $(findmnt -kn $@ | grep -v nodev) ] && echo -e "\t- 'nodev' option is set on $@ partition." || echo -e "\t- 'nodev' option is not set on $@ partition."
}

chk_nosuid(){
  [ -z $(findmnt -kn $@ | grep -v nosuid) ] && echo -e "\t- 'nosuid' option is set on $@ partition." || echo -e "\t- 'nosuid' option is not set on $@ partition."
}

chk_noexec(){
  [ -z $(findmnt -kn $@ | grep -v noexec) ] && echo -e "\t- 'noexec' option is set on $@ partition." || echo -e "\t- 'noexec' option is not set on $@ partition."
}

fs_parts=('/tmp' '/dev/shm' '/home' '/var' '/var/tmp' '/var/log' '/var/log/audit')

for parts in "${fs_parts[@]}";do 
  echo -e "\nAudit for $parts partition:"
  chk_sep_part "$parts"
  chk_nodev "$parts"
  chk_nosuid "$parts"
  chk_noexec "$parts"
done

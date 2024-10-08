#!/bin/bash

fix_sep_part(){
  [[ -n $(findmnt -kn $@) && -n $(grep $@ /etc/fstab) && -z $(findmnt -kn $@ | grep -v nodev) && -z $(findmnt -kn $@ | grep -v nosuid) && -z $(findmnt -kn $@ | grep -v noexec) ]] && echo -e "\t- No remedition is required!" || echo -e "\t- remedition required."
}

fix_sep_part '/tmp'

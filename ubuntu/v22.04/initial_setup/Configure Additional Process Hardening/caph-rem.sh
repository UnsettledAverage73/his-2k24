#!/bin/bash

installed-rem(){
  echo -e "\n- Audit for \"$@ installed check\":"
  if [[ -n "$(dpkg-query -s $@ 2> /dev/null)" ]]; then
    apt purge $@ -y &> /dev/null
    echo -e "\t- Remediation: **SUCCESS**"
  else 
    echo -e "\t- Remediation: Everything is **OK**"
  fi
}



pkgs=('prelink' 'apport')
for pkg in "${pkgs[@]}";do 
  installed-rem "$pkg"
done

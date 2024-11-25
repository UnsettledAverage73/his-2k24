#!/bin/bash

installed-chk(){
  echo -e "- Remidiation of apparmor installation:"
  if [[ -z "$(dpkg-query -s apparmor)" ]]; then
    apt install apparmor -y &> /dev/null && echo -e "\t- Remidiation: **SUCCESS**" || echo -e "\t- Remidiation: **FAILED**"
  fi

  echo -e "- Remidiation of apparmor-utils installation:"
  if [[ -z "$(dpkg-query -s apparmor-utils 2> /dev/null)" ]]; then
    apt install apparmor-utils -y &> /dev/null && echo -e "\t- Remidiation: **SUCCESS**" || echo -e "\t- Remidiation: **FAILED**"
  fi
}

profiles-rem(){
  echo -e "- Remidiation for apparmor profiles:"
  if [[ "$p_loaded" -ne "$p_enforce" ]]; then
    aa-enforce /etc/apparmor.d/* && echo -e "\t- Remidiation: **SUCCESS**" || echo -e "\t- Remidiation: **FAILED**"
  fi
}

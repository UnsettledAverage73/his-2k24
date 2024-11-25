#!/bin/bash

profiles-rem(){
  local output_p=''
  local output_f=''
  local logvr=''

  echo -e "- remidition for apparmor profiles:"
  if [[ "$p_loaded" -eq "$p_enforce" ]]; then
    output_p="$output_p\n\t - $(apparmor_status | grep -E 'profiles.*loaded')\n\t - $(apparmor_status | grep -E 'profiles.*enforce')"
    logvr=1
  else
    aa-enforce /etc/apparmor.d/*  
    output_p="$output_p\n\t - $(apparmor_status | grep -E 'profiles.*loaded')\n\t - $(apparmor_status | grep -E 'profiles.*enforce')"
    logvr=0
  fi

}

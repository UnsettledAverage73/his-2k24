#!/bin/bash

banner-chk(){
  l_pkgoutput=""
  if command -v dpkg-query &>/dev/null; then
    l_pq="dpkg-query -s"
  elif command -v rpm &>/dev/null; then
    l_pq="rpm -q"
  fi
  l_pcl="gdm gdm3" # Space separated list of packages to check
  for l_pn in $l_pcl; do
    $l_pq "$l_pn" &>/dev/null && l_pkgoutput="$l_pkgoutput\t - Package: \"$l_pn\" exists on the system"
  done
  if [ -n "$l_pkgoutput" ]; then
    l_output="" l_output2=""
    # Look for existing settings and set variables if they exist
    l_gdmfile="$(grep -Prils '^\h*banner-message-enable\b' /etc/dconf/db/*.d)"
    if [ -n "$l_gdmfile" ]; then
      # Set profile name based on dconf db directory ({PROFILE_NAME}.d)
      l_gdmprofile="$(awk -F\/ '{split($(NF-1),a,".");print a[1]}' <<< "$l_gdmfile")"
      # Check if banner message is enabled
      if grep -Pisq '^\h*banner-message-enable=true\b' "$l_gdmfile"; then
        l_output="$l_output\n\t - The \"banner-message-enable\" option is enabled in \"$l_gdmfile\""
      else
        l_output2="$l_output2\n\t - The \"banner-message-enable\" option is not enabled"
      fi
      l_lsbt="$(grep -Pios '^\h*banner-message-text=.*$' "$l_gdmfile")"
      if [ -n "$l_lsbt" ]; then
        l_output="$l_output\n\t - The \"banner-message-text\" option is set in \"$l_gdmfile\"\n - banner-message-text is set to:\n - \"$l_lsbt\""
      else
        l_output2="$l_output2\n\t - The \"banner-message-text\" option is not set"
      fi
      if grep -Pq "^\h*system-db:$l_gdmprofile" /etc/dconf/profile/"$l_gdmprofile"; then
        l_output="$l_output\n\t - The \"$l_gdmprofile\" profile exists"
      else
        l_output2="$l_output2\n\t - The \"$l_gdmprofile\" profile doesn't exist"
      fi
      if [ -f "/etc/dconf/db/$l_gdmprofile" ]; then
        l_output="$l_output\n\t - The \"$l_gdmprofile\" profile exists in the dconf database"
      else
        l_output2="$l_output2\n\t - The \"$l_gdmprofile\" profile doesn't exist in the dconf database"
      fi
    else
      l_output2="$l_output2\n\t - The \"banner-message-enable\" option isn't configured"
    fi
  else
    echo -e "\t- GNOME Desktop Manager isn't installed\n\t - Recommendation is Not Applicable\n\t- Audit result: **PASS**"
  fi
  # Report results. If no failures output in l_output2, we pass
  echo -e "\n- Audit for GDM login banner check:"
  if [ -z "$l_output2" ]; then
    echo -e "\t- Audit Result: **PASS** [GDM login banner configuration] $l_output"
    echo -e "$l_pkgoutput"
  else
    echo -e "\t- Audit Result: **FAIL** [GDM login banner configuration]\n\t- Reason(s) for audit failure:$l_output2"
    echo -e "$l_pkgoutput"
    [ -n "$l_output" ] && echo -e "\t- Correctly set:$l_output"
  fi
}

user-list-chk() {
  l_pkgoutput=""
  if command -v dpkg-query &>/dev/null; then
    l_pq="dpkg-query -s"
  elif command -v rpm &>/dev/null; then
    l_pq="rpm -q"
  fi
  l_pcl="gdm gdm3" # Space separated list of packages to check
  for l_pn in $l_pcl; do
    $l_pq "$l_pn" &>/dev/null && l_pkgoutput="$l_pkgoutput\t- Package:\"$l_pn\" exists on the system"
  done
  if [ -n "$l_pkgoutput" ]; then
    output="" output2=""
    l_gdmfile="$(grep -Pril '^\h*disable-user-list\h*=\h*true\b' /etc/dconf/db)"
    if [ -n "$l_gdmfile" ]; then
      output="$output\n\t - The \"disable-user-list\" option is enabled in \"$l_gdmfile\""
      l_gdmprofile="$(awk -F\/ '{split($(NF-1),a,".");print a[1]}' <<< "$l_gdmfile")"
      if grep -Pq "^\h*system-db:$l_gdmprofile" /etc/dconf/profile/"$l_gdmprofile"
      then
        output="$output\n\t - The \"$l_gdmprofile\" exists"
      else
        output2="$output2\n\t - The \"$l_gdmprofile\" doesn't exist"
      fi
      if [ -f "/etc/dconf/db/$l_gdmprofile" ]; then
        output="$output\n\t - The \"$l_gdmprofile\" profile exists in the dconf database"
      else
        output2="$output2\n\t - The \"$l_gdmprofile\" profile doesn't exist in the dconf database"
      fi
    else
      output2="$output2\n\t - The \"disable-user-list\" option is not enabled"
    fi
    echo -e "\n- Audit for GDM disable-user-list option:"
    if [ -z "$output2" ]; then
      echo -e "$l_pkgoutput\n\t- Audit result: **PASS** [GDM 'disable-user-list' option is enabled]$output"
    else
      echo -e "$l_pkgoutput\n\t- Audit Result: **FAIL** [GDM 'disable-user-list' option is disabled]$output2"
      [ -n "$output" ] && echo -e "$output"
    fi
  else
    echo -e "\t- GNOME Desktop Manager isn't installed\n Recommendation is Not Applicable\n\t- Audit result: **PASS**"
  fi
}

lock-chk() {
  l_delay=$(gsettings get org.gnome.desktop.screensaver lock-delay | awk '{ print $2 }')
  i_delay=$(gsettings get org.gnome.desktop.session idle-delay | awk '{ print $2 }')
  output_p=''
  output_f=''
  logvr=1

  if [[ "$l_delay" -le 5 ]]; then
    output_p="$output_p\n\t - lock-delay is configured properly."
  else
    output_f="$output_f\n\t - lock-delay isn't configured properly."  
    logvr=0
  fi

  if [[ "$i_delay" -le 900 && "$i_delay" -ne 0 ]]; then
    output_p="$output_p\n\t - idle-delay is configured properly."
  else
    output_f="$output_f\n\t - idle-delay isn't configured properly."  
    logvr=0
  fi

  echo -e "\n- Audit for GDM screen lock delay:"
  if [[ "$logvr" -eq 0 ]]; then
    echo -e "\t- Audit result: **FAIL** [GDM screen lock]"
    echo -e "\t- Reason: $output_f"
  else
    echo -e "\t- Audit result: **PASS** [GDM screen lock]"
    echo -e "\t- Reason: $output_p"
  fi
}

# banner-chk
# user-list-chk
lock-chk

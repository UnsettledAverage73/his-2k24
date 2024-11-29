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
    echo -e "\t- Audit Result: **PASS** $l_output"
    echo -e "$l_pkgoutput"
  else
    echo -e "\t- Audit Result: **FAIL**\n\t- Reason(s) for audit failure:$l_output2"
    echo -e "$l_pkgoutput"
    [ -n "$l_output" ] && echo -e "\t- Correctly set:$l_output"
  fi
}

banner-chk

#!/usr/bin/env bash
{
# Check if GNOME Desktop Manager is installed
l_pkgoutput=""
if command -v dpkg-query > /dev/null 2>&1; then
    l_pq="dpkg-query -W"
elif command -v rpm > /dev/null 2>&1; then
    l_pq="rpm -q"
fi

# Check if GDM is installed
l_pcl="gdm gdm3"
for l_pn in $l_pcl; do
    $l_pq "$l_pn" > /dev/null 2>&1 && l_pkgoutput="$l_pkgoutput\n - Package: \"$l_pn\" exists on the system\n - checking configuration"
done

# Check configuration (If applicable)
if [ -n "$l_pkgoutput" ]; then
    l_output="" l_output2=""
    echo -e "$l_pkgoutput\n"
    
    # Look for autorun-never to determine profile in use
    l_kfd="/etc/dconf/db/$(grep -Psril '^\h*autorun-never\b' /etc/dconf/db/*/ | awk -F'/' '{split($(NF-1),a,".");print a[1]}').d"
    
    if [ -d "$l_kfd" ]; then
        if grep -Priq '^\h*\/org/gnome\/desktop\/media-handling\/autorun-never\b' "$l_kfd"; then
            l_output="$l_output\n - \"autorun-never\" is locked in \"$(grep -Pril '^\h*\/org/gnome\/desktop\/media-handling\/autorun-never\b' "$l_kfd")\""
        else
            l_output2="$l_output2\n - \"autorun-never\" is not locked"
        fi
    else
        l_output2="$l_output2\n - \"autorun-never\" is not set so it cannot be locked"
    fi
else
    l_output="$l_output\n - GNOME Desktop Manager package is not installed on the system\n - Recommendation is not applicable"
fi

# Report results
if [ -z "$l_output2" ]; then
    echo -e "\n- Audit Result:\n ** PASS **\n$l_output\n"
else
    echo -e "\n- Audit Result:\n ** FAIL **\n - Reason(s) for audit failure:\n$l_output2\n"
    [ -n "$l_output" ] && echo -e "\n- Correctly set:\n$l_output\n"
fi
}


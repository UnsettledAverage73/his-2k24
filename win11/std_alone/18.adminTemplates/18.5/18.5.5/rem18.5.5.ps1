#!/bin/bash
# Title: CIS Control 18.5.5 (L1) - Ensure 'MSS: (EnableICMPRedirect) Allow ICMP Redirects to Override OSPF Generated Routes' is set to 'Disabled'

title="CIS Control 18.5.5 (L1) - Ensure 'MSS: (EnableICMPRedirect) Allow ICMP Redirects to Override OSPF Generated Routes' is set to 'Disabled'"
reg_path="/proc/sys/net/ipv4/conf/all/accept_redirects"
expected_value=0
sysctl_conf="/etc/sysctl.conf"

echo "Remediating: $title"

# Apply the setting for the current session
if [[ -f $reg_path ]]; then
    echo "$expected_value" > $reg_path
    echo "ICMP Redirects disabled for the current session."
else
    echo "$title - Remediation failed (Setting not found)."
    exit 1
fi

# Ensure the setting persists after reboot
if grep -q "^net.ipv4.conf.all.accept_redirects" $sysctl_conf; then
    sed -i "s/^net.ipv4.conf.all.accept_redirects.*/net.ipv4.conf.all.accept_redirects = $expected_value/" $sysctl_conf
else
    echo "net.ipv4.conf.all.accept_redirects = $expected_value" >> $sysctl_conf
fi

echo "$title - Remediation completed. ICMP Redirects are now disabled."


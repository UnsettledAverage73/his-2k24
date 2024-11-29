#!/bin/bash
# Title: CIS Control 18.5.5 (L1) - Ensure 'MSS: (EnableICMPRedirect) Allow ICMP Redirects to Override OSPF Generated Routes' is set to 'Disabled'

title="CIS Control 18.5.5 (L1) - Ensure 'MSS: (EnableICMPRedirect) Allow ICMP Redirects to Override OSPF Generated Routes' is set to 'Disabled'"
reg_path="/proc/sys/net/ipv4/conf/all/accept_redirects"
expected_value=0

echo "Checking compliance for: $title"

# Check if the setting is configured correctly
if [[ -f $reg_path ]]; then
    current_value=$(cat $reg_path)
    if [[ $current_value -eq $expected_value ]]; then
        echo "$title - Status: Compliant (ICMP Redirects are disabled)."
    else
        echo "$title - Status: Non-Compliant (Current value: $current_value)."
    fi
else
    echo "$title - Status: Non-Compliant (Setting not found)."
fi


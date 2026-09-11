#!/bin/bash
# StrongSwan IPsec VPN Automated Setup Script

ROLE=$1

if [ "$ROLE" == "cloud" ]; then
    echo "Configuring Cloud Router IPsec..."
    cat << 'CONF' > /etc/ipsec.conf
config setup
    uniqueids=yes

conn net-to-net
    auto=start
    left=192.168.56.10
    leftsubnet=10.0.0.0/16
    right=192.168.56.20
    rightsubnet=10.1.0.0/16
    authby=secret
    ike=aes256-sha256-modp2048!
    esp=aes256-sha256!
    keyingtries=%forever
CONF

    cat << 'SEC' > /etc/ipsec.secrets
192.168.56.20 192.168.56.10 : PSK "SuperSecretNetworkAutomationKey2026!"
SEC

elif [ "$ROLE" == "telco" ]; then
    echo "Configuring Telco Router IPsec..."
    cat << 'CONF' > /etc/ipsec.conf
config setup
    uniqueids=yes

conn net-to-net
    auto=start
    left=192.168.56.20
    leftsubnet=10.1.0.0/16
    right=192.168.56.10
    rightsubnet=10.0.0.0/16
    authby=secret
    ike=aes256-sha256-modp2048!
    esp=aes256-sha256!
    keyingtries=%forever
CONF

    cat << 'SEC' > /etc/ipsec.secrets
192.168.56.10 192.168.56.20 : PSK "SuperSecretNetworkAutomationKey2026!"
SEC
else
    echo "Usage: $0 [cloud|telco]"
    exit 1
fi

echo "IPsec configuration written successfully for $ROLE."

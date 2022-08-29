#!/bin/bash

get_my_ip () {
    dns_list=(
        "dig +short            Xmyip.opendns.com        @resolver1.opendns.com"
        "dig +short            Xmyip.opendns.com        @resolver2.opendns.com"
        "dig +short            Xmyip.opendns.com        @resolver3.opendns.com"
        "dig +short            Xmyip.opendns.com        @resolver4.opendns.com"
        "dig +short -4 -t a    whoami.akamai.net       @ns1-1.akamaitech.net"
        "dig +short            whoami.akamai.net       @ns1-1.akamaitech.net"
    )

    http_list=(
        ifconfig.me
        alma.ch/myip.cgi
        api.infoip.io/ip
        api.ipify.org
        bot.whatismyipaddress.com
        canhazip.com
        checkip.amazonaws.com
        eth0.me
        icanhazip.com
        ident.me
        ipecho.net/plain
        ipinfo.io/ip
        ipof.in/txt
        ip.tyk.nu
        l2.io/ip
        smart-ip.net/myip
        tnx.nl/ip
        wgetip.com
        whatismyip.akamai.com
    )

    eval dns=( \"\${dns_list[@]}\" )
    for cmd in "${dns[@]}"; do
        ip=$($cmd)
        if [ -n "$ip" ]; then
            echo $ip
            exit
        fi
    done

    if [ -n $ip ]; then
        eval http=( \"\${http_list[@]}\" ) \
        && for url in "${http[@]}"; do
            ip=$(curl -s $url)
            if [ -n "$ip" ]; then
                echo $ip
                exit
            fi
        done
    fi
}

get_my_ip

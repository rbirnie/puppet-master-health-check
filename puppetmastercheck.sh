#!/bin/bash
#
# Script to make a proxy (ie HAProxy) capable of monitoring puppet master nodes
#
# Author: Robert Birnie <rbirnie@gmail.com>
# Documentation and download: https://github.com/rbirnie/puppet-master-health-check
#
# Based on the original script from Unai Rodriguez and Olaf van Zandwijk
#

ERR_FILE="/dev/null"

#
# Curl puppet status for prod
#
puppet_status=`/usr/bin/curl -ksS -H "Accept: pson" https://<%= @fqdn %>:8140/production/status/no_key | \
               grep "\"is_alive\":true" >${ERR_FILE} 2>&1; echo $?`

if [ "${puppet_status}" == "0" ]
then
    # Puppetmaster is running => return HTTP 200
    /bin/echo -en "HTTP/1.1 200 OK\r\n"
    /bin/echo -en "Content-Type: text/plain\r\n"
    /bin/echo -en "Content-Length: 26\r\n"
    /bin/echo -en "\r\n"
    /bin/echo -en "Puppetmaster is running.\r\n"
else
    # Puppetmaster is off => return HTTP 503
    /bin/echo -en "HTTP/1.1 503 Service Unavailable\r\n"
    /bin/echo -en "Content-Type: text/plain\r\n"
    /bin/echo -en "Content-Length: 26\r\n"
    /bin/echo -en "\r\n"
    /bin/echo -en "Puppetmaster has failed.\r\n"
fi


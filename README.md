Puppet Master Health Check for HAProxy
==========================

A simple xinetd based health check to monitor puppet masters for load balancers (HAProxy). For more information on setup and configuration please see my blog post [Puppet Master Health Check for HAProxy](http://uberobert.com/puppet_master_health_check_haproxy/). I'll only have basic instructions here.

## Usage

Basic setup to change the HAProxy health check from the puppet port to a script that checks the actual status of the puppet master and can be enabled/disabled separately from puppet.

`/etc/haproxy/haproxy.cfg`

    # Load balanced puppetmasters
    listen puppetmaster_8140 10.0.0.100:8140
      mode tcp
      balance source
      hash-type map-based
      option httpchk
    
      server puppetmaster1 10.0.0.101:8140 check port 9200 inter 2000 rise 3 fall 3
      server puppetmaster1 10.0.0.102:8140 check port 9200 inter 2000 rise 3 fall 3
{% endhighlight %}

## Xinetd Setup

Place puppetmastercheck xinetd config within `/etc/xinet.d/`. Place the puppetmastercheck.sh somewhere on your puppetmaster to match the location specified in the xinetd config.

Finally, to get xinetd working you need to create the service used by the server. Add this line to your /etc/services file.

`puppetmastercheck      9200/tcp                # puppetmastercheck`

## Configure Puppet

Next we need to configure puppet for our fancy pancy script. Edit `/etc/puppet/auth.conf` to allow access to the `/status/` API URL. So add these lines to your auth.conf.


    # Allow access for HAProxy puppetmastercheck
    path /status
    auth any
    method find
    allow *


## Conclusion and Credits

Let me know either in the comments on the blog or open an issue here if you have any problems or recommendations. I'm not the sharpest tool in the shed so I'm sure there's a better way to do this!

The basis of the script and xinetd config was from the [Percona Clustercheck](https://github.com/olafz/percona-clustercheck) by Olaf van Zandwijk. Thanks!

zabbix-webcheck-provision
=========================

Simple scripts to create and remove webcheck using Zabbix API

Installation
============

You will need [my version of zabbixapi](https://github.com/jooray/zabbixapi), because
stock does not provide webcheck interface.

```
bundle install # may fail, because you don't have correct zabbixapi version
git clone https://github.com/jooray/zabbixapi.git
cd zabbixapi
rake install
cd ..
```

Now edit zb-provision.rb and zb-deprovision.rb providing your zabbix api
URL and credentials.

Usage
=====
```
ruby zb-provision.rb http://www.digmia.com/ 600
ruby zb-deprovision.rb www.digmia.com
```

Credits
=======

This simple software and modifications to zabbixapi were done by Juraj Bednar.
zb-provision and zb-deprovision scripts are under public domain. If you like
my work, you can donate Bitcoins to [1HSpHGZZxfNz3PDbFNTZLRzKfHtyGimKjk](bitcoin:1HSpHGZZxfNz3PDbFNTZLRzKfHtyGimKjk)

require "rubygems"
require 'bundler/setup'

require "zabbixapi"
require 'uri'
require "pp"  # for debugging only

@server_url="http://mon.example.com/zabbix/api_jsonrpc.php"

@login_user="admin"
@login_pass="zabbix"
@hostgroup="webchecks"

def destroy_webcheck(hostname, groupid)

  host_id = @zabbix.hosts.get_id(:host => hostname )
  unless host_id.nil?
     @zabbix.hosts.delete( :hostid => host_id )
  end
end

def connect
  @zabbix = ZabbixApi.connect(
      :url => @server_url,
      :user => @login_user,
      :password => @login_pass
  )
end


  connect()
  @groupid=@zabbix.hostgroups.get_id(:name => @hostgroup)
  destroy_webcheck(ARGV[0], @groupid )

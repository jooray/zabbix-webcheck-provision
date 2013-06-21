require "rubygems"
require 'bundler/setup'

require "zabbixapi"
require 'uri'
require "pp"  # for debugging only


@server_url="http://mon.example.com/zabbix/api_jsonrpc.php"

@login_user="admin"
@login_pass="zabbix"
@hostgroup="webchecks"
@webcheck_interval = 120


def create_webcheck(uri, groupid, delay)

  hostname=uri.host

  host_id = @zabbix.hosts.create_or_update(
      :host => hostname,
      :interfaces => [
          {
              :type => 1,
              :main => 1,
              :ip => '127.0.0.1',
              :dns => hostname,
              :port => 10050,
              :useip => 1
          }
      ],
      :groups => [ :groupid => groupid ]
  )

  app_id = @zabbix.applications.get_or_create(
      :name => "#{hostname}_web",
      :hostid => host_id
  )

  webcheck_id = @zabbix.webchecks.get_or_create(
      :name => "Homepage check #{hostname}",
      :applicationid => app_id,
      :hostid => host_id,
      :delay => delay,
      :steps => [
      {
          :name => "Homepage",
          :url => uri.to_s,
          :status_codes => 200,
          :no => 1
      }]
  )

  trigger_id = @zabbix.triggers.create_or_update(
      :description => "Webcheck failed for #{hostname}",
      :expression =>  "{#{hostname}:web.test.fail[Homepage check #{hostname}].last(0)}>0",
      :priority => 5,
      :type => 0
  )

  webcheck_id

end

def connect
  @zabbix = ZabbixApi.connect(
      :url => @server_url,
      :user => @login_user,
      :password => @login_pass
  )
end


begin

  connect()
  @groupid=@zabbix.hostgroups.get_id(:name => @hostgroup)
  create_webcheck(URI(ARGV[0]), @groupid, ARGV[1].nil? ? @webcheck_interval : ARGV[1].to_i)

rescue ZbxAPI_ExceptionLoginPermission, ZbxAPI_ParameterError => e
  pp e
  exit
end
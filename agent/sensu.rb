module MCollective
  module Agent
    class Sensu<RPC::Agent

      action "runallchecks" do
        reply[:checks] = {}
        cdirs = Config.instance.pluginconf["sensu.conf_dir"] || "/etc/sensu/conf.d"
        sensu_dir = Config.instance.pluginconf["sensu.install_dir"] || "/opt/sensu"

        reply[:status] = run("#{sensu_dir}/embedded/bin/sensu-run-check -d #{cdirs} -R", :stdout => :output, :stderr => :err)

        reply[:output].each do |check_line|
          # Run all returns: <check_name> <status> <stdout>
          name, status, stdout = /(\w+) (\d+) (.*)/.match(check_line).captures
          reply[:checks][name] = {
            :output => stdout,
            :status => status,
          }
        end

        case reply[:status]
          when 0
            reply.statusmsg = "OK"

          when 1
            reply.fail "WARNING"

          when 2
            reply.fail "CRITICAL"

          else
            reply.fail "UNKNOWN"
        end
      end

      action "runcheck" do
        cdirs = Config.instance.pluginconf["sensu.conf_dir"] || "/etc/sensu/conf.d"
        sensu_dir = Config.instance.pluginconf["sensu.install_dir"] || "/opt/sensu"

        reply[:status] = run("#{sensu_dir}/embedded/bin/sensu-run-check -d #{cdirs} -r #{request[:check]}", :stdout => :output, :stderr => :err)
        reply[:check] = request[:check]

        case reply[:status]
          when 0
            reply.statusmsg = "OK"

          when 1
            reply.fail "WARNING"

          when 2
            reply.fail "CRITICAL"

          else
            reply.fail "UNKNOWN"
        end
      end

      activate_when do
        sensu_dir = Config.instance.pluginconf["sensu.install_dir"] || "/opt/sensu"
        File.executable?("#{sensu_dir}/embedded/bin/sensu-run-check")
      end
    end
  end
end

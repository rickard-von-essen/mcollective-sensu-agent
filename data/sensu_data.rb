module MCollective
  module Data
    class Sensu_data<Base

      # Only activate Sensu data plugin if agent plugin has been loaded
      activate_when{ PluginManager["sensu_agent"] }

      query do |check|
        begin
          # TODO shell escape check in command
          Log.debug("Running Sensu check '#{check}'")
          cdirs = Config.instance.pluginconf["sensu.conf_dir"] || "/etc/sensu/conf.d"
          sensu_dir = Config.instance.pluginconf["sensu.install_dir"] || "/opt/sensu"
          shell = Shell.new("#{sensu_dir}/embedded/bin/sensu-run-check -d #{cdirs} -r #{check}")
          shell.runcommand
          result[:status] = shell.status.exitstatus

        rescue => e
          Log.warn("Could not get status for Sensu check #{check}: #{e.to_s}")
        end
      end
    end
  end
end

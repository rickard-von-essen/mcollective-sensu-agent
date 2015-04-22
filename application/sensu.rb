class MCollective::Application::Sensu<MCollective::Application
  description "Client to the Sensu Remote Check Execution system"
  usage "Usage: sensu check <check_name>"
  usage "       sensu checkall"

  option :check,
    :description => "Run CHECK",
    :arguments   => ["-r", "--check CHECK"]

  option :checkall,
    :description => "Run all checks",
    :arguments   => ["-R", "--checkall"],
    :type        => :bool

  def validate_configuration(configuration)
    raise "Please specify an action: --check|--checkall" unless
    configuration.include?(:check) || configuration.include?(:checkall)
  end

  def main
    sensu = rpcclient("sensu")

    if configuration[:checkall]
      sensu_results = sensu.runallchecks
    else
      sensu_results = sensu.runcheck(:check => configuration[:check])
    end

    sensu_results.each do |result|
      exitcode = Integer(result[:data][:status]) rescue 3

      if sensu.verbose
        printf("%-40s status=%s\n", result[:sender], result[:statusmsg])
        printf("    %-40s\n\n", result[:data][:output])
      else
        if [1,2,3].include?(exitcode)
          printf("%-40s status=%s\n", result[:sender], result[:statusmsg])
          if result[:data][:checks]
            first_notok = result[:data][:checks].select{ |check, check_res| Integer(check_res[:status]) == exitcode }.first[0]
            printf("    %-40s\n\n", result[:data][:checks][first_notok][:output]) if result[:data][:checks][first_notok]
          else
            printf("    %-40s\n\n", result[:data][:output].split('\n').first) if result[:data][:output]
          end
        end
      end
    end

    printrpcstats :summarize => true, :caption => "%s Sensu check results" % configuration[:check]
    halt sensu.stats
  end
end

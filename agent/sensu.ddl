metadata    :name        => "sensu",
            :description => "Agent to query Sensu checks via MCollective",
            :author      => "Rickard von Essen",
            :license     => "ASL 2.0",
            :version     => "0.1.0",
            :url         => "http://github.com/rickard-von-essen/mcollective-sensu-agent",
            :timeout     => 5

requires :mcollective => "2.2.1"

action "runcheck", :description => "Run a Sensu check" do
    input :check,
          :prompt      => "Check",
          :description => "Sensu check to run",
          :type        => :string,
          :validation  => '\A[a-zA-Z0-9_-]+\z',
          :optional    => false,
          :maxlength   => 50

    output :output,
           :description => "Output from the Sensu check",
           :display_as  => "Output",
           :default     => ""

    output :status,
           :description  => "Exit Code from the Sensu check",
           :display_as   => "Exit Code",
           :default      => 3

    if respond_to?(:summarize)
        summarize do
            aggregate sensu_states(:status)
        end
    end
end

action "runallchecks", :description => "Run all defined Sensu checks" do
    output :checks,
           :description => "Output status of all defined checks",
           :display_as  => "Checks"

    output :status,
           :description  => "Worst Exit Code from the Sensu checks",
           :display_as   => "Worst Exit Code",
           :default      => 3

    if respond_to?(:summarize)
        summarize do
            aggregate sensu_states(:status)
        end
    end
end

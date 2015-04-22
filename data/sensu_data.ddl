metadata  :name         => "sensu",
          :description  => "Checks the exit codes of executed Sensu checks",
          :author       => "Rickard von Essen",
          :license      => "ASL 2.0",
          :version      => "0.1.0",
          :url          => "http://github.com/rickard-von-essen/mcollective-sensu-agent",
          :timeout      => 4

requires :mcollective => "2.2.1"

usage <<-END_OF_USAGE
Checks the status of a service. This plugin can be used during discovery and everywhere else
the mcollective discovery language is used.

Example Usage:

  During Discovery -  mco rpc rpcutil ping -S "service('puppet').status=running"
  Action Policy    -  service('puppet').status=stopped

END_OF_USAGE

dataquery :description => "Runs a Sensu check and returns the exit code" do
  input   :query,
          :prompt       => "Check",
          :description  => "Valid Sensu check",
          :type         => :string,
          :validation   => '\A[a-zA-Z0-9_-]+\z',
          :maxlength    => 20

  output  :status,
          :description => "Status (exit code) of Sensu check",
          :display_as  => "Status"
end

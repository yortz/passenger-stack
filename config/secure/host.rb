package :update_host, :provides => :host do
  description 'Updates hosts and hostname'
  
  requires :hosts, :hostname
end

package :hosts do
  description "Firewall rules"
  transfer File.join(File.dirname(__FILE__), '../../assets/hosts'), "/tmp" do
    post :install, %{mv /tmp/hosts /etc/hosts}
  end
  verify do
    file_contains "/etc/hosts", "127.0.0.1       #{HOST}"
  end
end

package :hostname do
  description "Create hostname file"
  
  hostname_file = '/etc/hostname'
  runner "echo #{HOST} > #{hostname_file}"
  runner "hostname -F #{hostname_file}"
  
  verify do
    file_contains hostname_file, HOST
  end
end

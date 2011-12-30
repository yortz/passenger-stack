package :iptables do
  description "Firewall"
  runner %{/sbin/iptables-restore < /etc/iptables.up.rules; sudo /etc/init.d/ssh reload}
  requires :ssh, :iptables_rules, :iptables_ifconfig
end

package :iptables_rules do
  description "Firewall rules"
  transfer File.join(File.dirname(__FILE__), '../../assets/iptables'), "/tmp" do
    post :install, %{mv /tmp/iptables /etc/iptables.up.rules}
  end
  verify do
    has_file "/etc/iptables.up.rules"
  end
end

package :iptables_ifconfig do
  description "Setup firewall with network"
  transfer File.join(File.dirname(__FILE__), '../../assets/iptables_ifup'), "/tmp" do
    post :install, %{mv /tmp/iptables_ifup /etc/network/if-pre-up.d/iptables}
    post :install, %{chmod +x /etc/network/if-pre-up.d/iptables}
  end
  verify do
    has_executable "/etc/network/if-pre-up.d/iptables"
  end
end
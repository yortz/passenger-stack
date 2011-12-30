package :ssh do
  description "Create the deploy user"
  
  runner "useradd --create-home --shell /bin/bash --user-group --groups users,sudo #{USER_TO_ADD}"
  runner "echo '#{USER_TO_ADD}:#{USER_PWD}' | chpasswd"
  
  optional :add_user_ssh_keys, :set_permissions, :user_allow_sudo, :sshd_config
  
  verify do
    has_directory "/home/#{USER_TO_ADD}"
  end
end

package :add_user_ssh_keys do
  description "Add deployer public key to authorized ones"
  
  id_rsa_pub = `cat #{PUBLIC_KEY_PATH}/#{KEY}`
  authorized_keys_file = "/home/#{USER_TO_ADD}/.ssh/authorized_keys"
  
  push_text id_rsa_pub, authorized_keys_file do
    # Ensure there is a .ssh folder.
    pre :install, "mkdir -p /home/#{USER_TO_ADD}/.ssh"
  end
  
  verify { has_file "/home/#{USER_TO_ADD}/.ssh/authorized_keys" }
end

package :set_permissions do
  description "Set correct permissons and ownership"
  
  runner "chmod 0700 /home/#{USER_TO_ADD}/.ssh"
  runner "chown -R #{USER_TO_ADD}:#{USER_TO_ADD} /home/#{USER_TO_ADD}/.ssh"  
  runner "chmod 0700 /home/#{USER_TO_ADD}/.ssh/authorized_keys"
end

package :user_allow_sudo do
  description "Allow added user to perform sudo commands"
  
  sudo_conf = '/etc/sudoers'
  sudo_config = %Q\
# Allow #{USER_TO_ADD} user sudo
yortz ALL=NOPASSWD: ALL
  \

  push_text sudo_config, sudo_conf  
  
  verify { file_contains sudo_conf, "Allow #{USER_TO_ADD} user sudo" }
end

package :sshd_config do
  description "Default SSHD config"
  
  config_file = '/etc/ssh/sshd_config'
  config_template = File.join(File.dirname(__FILE__), '../../assets/sshd_config')
  
  transfer config_template, config_file do
    post :install, "/etc/init.d/ssh reload"
  end
  
  verify { file_contains config_file, 'Port 36697'}
end

%w[start stop restart reload].each do |command|
  package :"ssh_#{command}" do
    runner "/etc/init.d/ssh #{command}"
  end
end
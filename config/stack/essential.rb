package :build_essential do
  description 'Build tools'
  apt 'build-essential' do
    pre :install, 'apt-get update'
  end
end

package :terminal_colors do
  description "enables colors in prompt"
  
  colors = %Q\
# Enabling colors
force_color_prompt=yes
\
  bashrc = "/home/yortz/.bashrc"
  
  push_text colors, bashrc
  
  bash_reload = %Q\
#.bashrc is not sourced when you log in using SSH. You need to source it in your .bash_profile like this:

if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi
\

  bash_profile = "/home/yortz/.bash_profile"
  
  push_text bash_reload, bash_profile
  
  #runner "echo 'source .bashrc'"
  
  verify { file_contains bashrc, "# Enabling colors" }
end

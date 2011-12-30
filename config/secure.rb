$: << File.dirname(__FILE__)

require 'setup'
require 'secure/ssh'
require 'secure/iptables'
require 'secure/host'

# What we're installing to your server
# Take what you want, leave what you don't
# Build up your own and strip down your server until you get it right. 
policy :secure, :roles => :app do
  requires :ssh
  requires :iptables
  requires :host
end

deployment do
  # mechanism for deployment
  delivery :capistrano do
    begin
      recipes 'Capfile'
    rescue LoadError
      recipes 'deploy'
    end
  end

end

# Depend on a specific version of sprinkle 
begin
  gem 'sprinkle', ">= 0.3.3" 
rescue Gem::LoadError
  puts "sprinkle 0.3.3 required.\n Run: `sudo gem install sprinkle`"
  exit
end
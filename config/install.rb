$:<< File.join(File.dirname(__FILE__), 'stack')

require File.expand_path(File.join(File.dirname(__FILE__), "setup"))

# Require the stack base
%w(essential git ruby_mri mysql apache image_management utils).each do |lib|
  require lib
end


# What we're installing to your server
# Take what you want, leave what you don't
# Build up your own and strip down your server until you get it right. 
policy :passenger_stack, :roles => :app do
  requires :webserver               # Apache
  requires :fixhost                 # fixes the apache2: Could not reliably determine the server's fully qualified domain name, using 127.0.0.1 for ServerName
  requires :appserver               # Passenger
  requires :ruby                    # Ruby 1.9.2
  requires :gems                    # default gems
  requires :set_path                # set correct path to gems exec so that it finds bundle command
  requires :image_management        # ImageMagick
  requires :database                # MySQL
  requires :scm                     # Git
  requires :tools                   # Several Utilities such as Vim and other stuff (edit this to your own needs) 
  requires :terminal_colors         # enhanced terminal colors
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
 
  # source based package installer defaults
  source do
    prefix   '/usr/local'
    archives '/usr/local/sources'
    builds   '/usr/local/build'
  end
end

# Depend on a specific version of sprinkle 
begin
  gem 'sprinkle', ">= 0.3.3" 
rescue Gem::LoadError
  puts "sprinkle 0.3.3 required.\n Run: `sudo gem install sprinkle`"
  exit
end
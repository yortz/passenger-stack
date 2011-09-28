$:<< File.join(File.dirname(__FILE__), 'stack')

# Require the stack base
%w(essential bundler git ruby_mri ruby_enterprise memcached postgresql mysql mongodb apache image_management).each do |lib|
  require lib
end

# What we're installing to your server
# Take what you want, leave what you don't
# Build up your own and strip down your server until you get it right. 
policy :passenger_stack, :roles => :app do
  requires :webserver               # Apache
  requires :appserver               # Passenger
  requires :ruby                      # REE or MRI Ruby
  requires :bundler                   # Bundler
  requires :image_management        # ImageMagick
  requires :database                # MongoDB, MySQL or Postgres
  requires :scm                     # Git
  # requires :memcached               # Memcached
  # requires :libmemcached            # Libmemcached
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
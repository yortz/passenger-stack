package :apache, :provides => :webserver do
  description 'Apache2 web server.'
  apt 'apache2 apache2.2-common apache2-mpm-prefork apache2-utils libexpat1 ssl-cert libcurl4-openssl-dev' do
    post :install, 'a2enmod rewrite'
  end

  verify do
    has_executable '/usr/sbin/apache2'
  end

  requires :build_essential
  optional :apache_etag_support, :apache_deflate_support, :apache_expires_support
end

package :apache2_prefork_dev do
  description 'A dependency required by some packages.'
  apt 'apache2-prefork-dev'
end

package :passenger, :provides => :appserver do
  description 'Phusion Passenger (mod_rails)'
  version '3.0.11'
  binaries = %w(passenger-config passenger-install-nginx-module passenger-install-apache2-module passenger-make-enterprisey passenger-memory-stats passenger-spawn-server passenger-status passenger-stress-test)
  
  gem 'passenger' do
    
    binaries.each {|bin| post :install, "ln -s #{RUBY_PATH}/bin/#{bin} /usr/local/bin/#{bin}"}
    
    post :install, 'echo -en "\n\n\n\n" | sudo passenger-install-apache2-module'

    # Create the passenger conf file
    post :install, 'mkdir -p /etc/apache2/extras'
    post :install, 'touch /etc/apache2/extras/passenger.conf'
    post :install, 'echo "Include /etc/apache2/extras/passenger.conf"|sudo tee -a /etc/apache2/apache2.conf'

    [%Q(LoadModule passenger_module #{RUBY_PATH}/lib/ruby/gems/1.9.1/gems/passenger-#{version}/ext/apache2/mod_passenger.so),
    %Q(PassengerRoot #{RUBY_PATH}/lib/ruby/gems/1.9.1/gems/passenger-#{version}),
    %q(PassengerRuby /usr/local/bin/ruby),
    %q(RackEnv production),
    %q(RailsEnv production)].each do |line|
      post :install, "echo '#{line}' |sudo tee -a /etc/apache2/extras/passenger.conf"
    end

    # Restart apache to note changes
    post :install, '/etc/init.d/apache2 restart'
  end

  verify do
    has_file "/etc/apache2/extras/passenger.conf"
    has_file "#{RUBY_PATH}/lib/ruby/gems/1.9.1/gems/passenger-#{version}/ext/apache2/mod_passenger.so"
    has_directory "#{RUBY_PATH}/lib/ruby/gems/1.9.1/gems/passenger-#{version}"
  end

  requires :apache, :apache2_prefork_dev, :ruby
end

# These "installers" are strictly optional, I believe
# that everyone should be doing this to serve sites more quickly.

# Enable ETags
package :apache_etag_support do
  apache_conf = "/etc/apache2/apache2.conf"
  config = <<eol
  # Passenger-stack-etags
  FileETag MTime Size
eol

  push_text config, apache_conf, :sudo => true
  verify { file_contains apache_conf, "Passenger-stack-etags"}
end

# mod_deflate, compress scripts before serving.
package :apache_deflate_support do
  apache_conf = "/etc/apache2/apache2.conf"
  config = <<eol
  # Passenger-stack-deflate
  <IfModule mod_deflate.c>
    # compress content with type html, text, and css
    AddOutputFilterByType DEFLATE text/css text/html text/javascript application/javascript application/x-javascript text/js text/plain text/xml
    <IfModule mod_headers.c>
      # properly handle requests coming from behind proxies
      Header append Vary User-Agent
    </IfModule>
  </IfModule>
eol

  push_text config, apache_conf, :sudo => true
  verify { file_contains apache_conf, "Passenger-stack-deflate"}
end

# mod_expires, add long expiry headers to css, js and image files
package :apache_expires_support do
  apache_conf = "/etc/apache2/apache2.conf"

  config = <<eol
  # Passenger-stack-expires
  <IfModule mod_expires.c>
    <FilesMatch "\.(jpg|gif|png|css|js)$">
         ExpiresActive on
         ExpiresDefault "access plus 1 year"
     </FilesMatch>
  </IfModule>
eol

  push_text config, apache_conf, :sudo => true
  verify { file_contains apache_conf, "Passenger-stack-expires"}
end

package :fixhost do
  description "FIX apache2: Could not reliably determine the server's fully qualified domain name, using 127.0.0.1 for ServerName"
  
  servername_conf = '/etc/apache2/conf.d/servername.conf'
  servername_config = %Q\
ServerName #{USER_TO_ADD}
  \

  runner 'sudo touch /etc/apache2/conf.d/servername.conf'
  push_text servername_config, servername_conf, :sudo => true
  
  verify { file_contains servername_conf, "ServerName #{USER_TO_ADD}" }
  
  requires :webserver
  
end

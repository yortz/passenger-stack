package :mysql, :provides => :database do
  description 'MySQL Database'
  apt %w( mysql-server mysql-client libmysqlclient15-dev ) do
    post :install do
      runner "mysqladmin -u root password #{DB_ROOT_PWD} "
    end
  end
  
  verify do
    has_executable 'mysqld'
  end
  
  optional :mysql_driver

end
 
package :mysql_driver, :provides => :ruby_database_driver do
  description 'Ruby MySQL database driver'
  gem 'mysql2'
  
  verify do
    has_gem 'mysql2'
  end
  
  requires :ruby
end
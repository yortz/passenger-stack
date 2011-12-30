package :git, :provides => :scm do
  description 'Git Distributed Version Control'
  version '1.7.8'
  source "http://git-core.googlecode.com/files/git-#{version}.tar.gz"
  requires :git_dependencies
  
  verify do
    has_executable 'git'
  end
end

package :git_dependencies do
  description 'Git Build Dependencies'
  apt 'git-core', :dependencies_only => true
end

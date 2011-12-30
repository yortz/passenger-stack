package :ruby_mri, :provides => :ruby do
  description 'MRI Ruby'
  version '1.9.2-p290'
  binaries = %w(erb gem irb rackup rails rake rdoc ri ruby testrb bundle)
  source "http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-#{version}.tar.gz" do
    prefix RUBY_PATH
    binaries.each {|bin| post :install, "sudo ln -s #{RUBY_PATH}/bin/#{bin} /usr/local/bin/#{bin}" }
  end
  
  verify do
    has_directory RUBY_PATH
  end

  requires :ruby_mri_dependencies
end

package :ruby_mri_dependencies do
  apt %w(zlib1g-dev libreadline-gplv2-dev libssl-dev libxslt-dev libxml2-dev ruby-bundler nodejs)
  requires :build_essential
end

package :gems do
  description 'Bundler'
  
  runner "sudo gem update --system; sudo gem install bundler rails --no-rdoc --no-ri"

  requires :ruby_mri
end

package :set_path do
  description "set correct path to gems exec so that it finds bundle command"
  
  path = "PATH=\"/usr/local/ruby/bin:$PATH\""
  bash_profile = "/home/yortz/.bash_profile"
  
  push_text path, bash_profile
  
  verify { file_contains bash_profile, path}
end
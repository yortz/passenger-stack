package :ruby_mri, :provides => :ruby do
  description 'MRI Ruby'
  version '1.9.2-p290'
  RUBY_PATH = "/usr/local/ruby"
  binaries = %w(erb gem irb rackup rails rake rdoc ri ruby testrb)
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
  apt %w(zlib1g-dev libreadline5-dev libssl-dev libxslt-dev libxml2-dev)
  requires :build_essential
end
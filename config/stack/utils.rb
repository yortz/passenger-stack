package :utilities, :provides => :tools do
  description "Tools: Common tools needed by applications or for operations"

  requires  :ntp, :screen, :curl, :vim, :htop, :rsync
end

package :ntp do
  description 'ntp'
  
  apt 'ntp' do
    post :install, 'ntpdate ntp.ubuntu.com'
  end

  verify do
    has_executable 'ntpdate'
  end
end

package :screen do
  description 'screen'
  
  apt 'screen'

  verify do
    has_executable 'screen'
  end
end

package :curl do
  description 'curl'
  
  apt 'curl'

  verify do
    has_executable 'curl'
  end
end

package :vim do
  description 'vim'
  
  apt 'vim'
  
  verify do
    has_executable 'vim'
  end
end

package :htop do
  description 'htop'
  
  apt 'htop'
  
  verify do
    has_executable 'htop'
  end
end

package :rsync do
  description 'rsync'

  apt 'rsync'

  verify do
    has_executable 'rsync'
  end
end
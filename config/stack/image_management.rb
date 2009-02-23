package :image_magick, :provides => :image_management do
  description 'ImageMagick is a software suite to create, edit, and compose bitmap images.'
  apt %w( imagemagick librmagick-ruby1.8 libmagick9-dev librmagick-ruby-doc libfreetype6-dev xml-core )
  
  verify do
    has_executable 'identify'
  end
end
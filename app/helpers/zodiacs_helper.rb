module ZodiacsHelper
  # One approach is to have the logic of the images displayed for a given zodiac confined
  # to a View Helper because that kind of logic isn't typically within the purview of what
  # a Model in the MVC paradigm is supposed to be concerned with.
  
  def zodiac_image_for(user, size=:thumb)
    image_tag("#{user.zodiac}_#{size}.jpg", :class => "#{user.zodiac} zodiac_#{size}")
  end
  
  def zodiac_attributes(user)
    
  end
end

module ApplicationHelper 
  
  def title
    base_title = "Ehalmony"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end
  
  # This is just a quick implementation that didn't yet take into account any graphics you might
  # want to put into the button, but those can be handled strictly from the CSS level by
  # referencing the class names specific to each button type, for instance:
  #
  # /* The following assumes the icon is 10px wide or less.
  # .mkd_button { padding-left: 10px; background: transparent url('invalid_icon.png') no-repeat top left; }
  # .marry_button { background-image: url('marry_button_icon.png'); }
  # .kiss_button  { background-image: url('kiss_button_icon.png'); }
  def marry_button_for(user)
    mkd_button_for(user, :marry)
  end
  
  def kiss_button_for(user)
    mkd_button_for(user, :kiss)
  end
  
  def date_button_for(user)
    mkd_button_for(user, :date)
  end
    
  private
  def mkd_button_for(user, type)
    button_to type, send(:"#{type}_user_path", user), :class => "#{type}_button mkd_button"
    # for example:
    #   mkd_button_for(user, :marry)
    # results in:
    #   => button_to :marry, marry_user_path(user), :method => :post, :class => "marry_button"
    # which assumes you have a route.rb entry such as:
    #   resources :users do
    #     member do
    #       post 'marry'
    #       post 'kiss'
    #       post 'date'
    #     end
    #   end
    #
    # As an aside, that can be abbreviated (in one particular way) as:
    #   resources :users do
    #     %w(marry kiss date).each { |type| post type }
    #   end
    #
    # ... which, I assume you know already, assumes you have actions in the UsersController file for
    # each of those types (marry, kiss, or date)
  end
end

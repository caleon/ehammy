class User < ActiveRecord::Base    
  
  attr_accessor :password
  attr_accessible :name, :email, :password, :password_confirmation, :birthday
  
  before_save :encrypt_password     
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i 
  
  validates :name,      :presence     =>  true,
                        :length       =>  { :maximum => 50 }
  
  validates :email,     :presence     =>  true,
                        :format       =>  { :with =>  email_regex }, 
                        :uniqueness   =>  { :case_sensitive => false }

  validates :password,  :presence     =>  true,
                        :confirmation =>  true,
                        :length       => { :within => 6..12 }    
  validates :birthday,  :presence     => true  
                
                        
  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end
  
  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil if user.nil?
    return user if user.has_password?(submitted_password)
  end  
  
  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end                     
  
  ######################
  ## Alternate method ##
  ######################
  #
  # If using this method, you need to get rid of the Zodiac model file in app/models out of
  # caution because there may be name-clashes with the "Zodiac" constant. However, the official
  # name of this Zodiac class below is User::Zodiac (vs. simply Zodiac) but while within the scope
  # of the User model, it's possible to just refer to it as "Zodiac".
  #
  # With this approach, there is no need to set another column in any table. This kind of approach
  # is often more suitable when it comes to a model with fixed data (because Zodiac date ranges are
  # fairly static and inflexible).
  #
  # Pretty much, when you do a call like @user.zodiac, it will do the calculation at runtime, which
  # isn't very taxing the way I'd written it below. The call @user.zodiac will return a symbol such
  # as :rat.
  #
  class Zodiac
    # The following date ranges are lifted from http://en.wikipedia.org/wiki/Chinese_zodiac    
    TYPES = {
        :rat      => [%w(1924/2/5 1925/1/23),
                      %w(1936/1/24 1937/2/10),
                      %w(1948/2/10 1949/1/28),
                      %w(1960/1/28 1961/2/14),
                      %w(1972/2/15 1973/2/2),
                      %w(1984/2/2 1985/2/19),
                      %w(1996/2/19 1997/2/6),
                      %w(2008/2/7 2009/1/25)
                   ],
        :ox       => [%w(1925/1/24 1926/2/12),
                      %w(1937/2/11 1938/1/30),
                      %w(1949/1/29 1950/2/16),
                      %w(1961/2/15 1962/2/4), 
                      %w(1973/2/3 1974/1/22), 
                      %w(1985/2/20 1986/2/8), 
                      %w(1997/2/7 1998/1/27), 
                      %w(2009/1/26 2010/2/13)
                       ],
        :tiger    => [%w(1926/2/13 1927/2/1),
                      %w(1938/1/31 1939/2/18),
                      %w(1950/2/17 1951/2/5),
                      %w(1962/2/5 1963/1/24),
                      %w(1974/1/23 1975/2/10),
                      %w(1986/2/9 1987/1/28),
                      %w(1998/1/28 1999/2/15),
                      %w(2010/2/14 2011/2/2)
                      ],
        :rabbit   => [%w(1927/2/2 1928/1/22), 
                      %w(1939/2/29 1940/2/7),
                      %w(1951/2/6 1952/1/26),
                      %w(1963/1/25 1964/2/12),
                      %w(1975/2/11 1976/1/30),
                      %w(1987/1/29 1988/2/16),
                      %w(1999/2/16 2000/2/4),
                      %w(2011/2/3 2012/1/22)
            ],
        :dragon   => [%w(1928/1/23 1929/2/9),
                      %w(1940/2/8 1941/1/26),
                      %w(1952/1/27 1953/2/13),
                      %w(1964/2/13 1965/2/1), 
                      %w(1976/1/31 1977/2/17),
                      %w(1988/2/17 1989/2/5),
                      %w(2000/2/5 2001/1/23),
                      %w(2012/1/23 2013/2/9)
            ],
        :snake    => [%w(1929/2/10 1930/1/29), 
                      %w(1941/1/27 1942/2/14), 
                      %w(1953/2/14 1954/2/2),
                      %w(1965/2/2 1966/1/20), 
                      %w(1977/2/18 1978/2/6),
                      %w(1989/2/6 1990/1/26),
                      %w(2001/1/24 2002/2/11)
          ],
      
        :horse    => [%w(1930/1/30 1931/2/15),
                      %w(1942/2/15 1943/2/4), 
                      %w(1954/2/3 1955/1/23),
                      %w(1966/1/21 1966/2/8),
                      %w(1978/2/7 1979/1/27),
                      %w(1990/1/27 1991/2/14),
                      %w(2002/2/12 2003/1/31)
          ],
        :goat     => [%w(1931/2/17 1932/2/5),
                      %w(1943/2/5 1944/1/24),
                      %w(1955/1/24 1956/2/11),
                      %w(1967/2/9 1968/1/29),
                      %w(1979/1/28 1980/2/15),
                      %w(1991/2/15 1992/2/3),
                      %w(2003/2/1 2004/1/21)
          ],
        :monkey   => [%w(1932/2/6 1933/1/25),
                      %w(1944/1/25 1945/2/12),
                      %w(1956/2/12 1957/1/30),
                      %w(1968/1/30 1969/2/16),
                      %w(1980/2/16 1981/2/4),
                      %w(1992/2/4 1993/1/22),
                      %w(2004/1/22 2005/2/8)
                    
          ],
        :rooster  => [%w(1933/1/26 1934/2/13),
                      %w(1945/2/13 1946/2/1),
                      %w(1957/1/31 1958/2/17), 
                      %w(1969/2/17 1970/2/5),
                      %w(1981/2/5 1982/1/24),
                      %w(1993/1/23 1994/2/9),
                      %w(2005/2/9 2006/1/28)
          ],
        :dog      => [%w(1934/2/14 1935/2/3),
                      %w(1946/2/2 1947/1/21), 
                      %w(1958/2/18 1959/2/7), 
                      %w(1970/2/6 1971/1/26),
                      %w(1982/1/25 1983/2/12),
                      %w(1994/2/10 1995/1/30),
                      %w(2006/1/29 2007/2/6)
            ],
        :pig      => [%w(1935/2/4 1936/1/23),
                      %w(1947/1/22 1948/2/9),
                      %w(1959/2/8 1960/1/27),
                      %w(1971/1/26 1972/2/14),
                      %w(1983/2/13 1984/2/1), 
                      %w(1995/1/31 1996/2/18),
                      %w(2007/2/18 2008/2/6)
          ]            
       }.freeze
       
    def self.for_birthdate(bdate)
     TYPES.detect do |animal, low_and_highs_array|
       low_and_highs_array.detect do |low_and_high|
         low, high = low_and_high.map { |date_str| Date.new(*date_str.split('/').map(&:to_i)) }
         (low..high).include?(bdate)
       end
     end.first # because the result of detect looksl ike [ :rat, blahblah ]
     # result is the chinese zodiac animal name as a symbol, i.e. :rat
    end
    
    ATTRIBUTES = {
        :rat      =>  {:positive => ["good businessman", "hard-working", "cunning"], 
                       :negative => %w[stingy]},
      
        :ox       =>  {:positive => %w[perserverance honest hard-working],
                       :negative => %w[stubborn]}, 
                     
        :tiger    =>  {:positive => %w[passionate brave optimistic],
                       :negative => ["sometimes unreliable"]},        
                     
        :rabbit   =>  {:positive => %w[ambitious fashionable graceful],
                       :negative => ["can be lonely at times"]},
                     
        :dragon   =>  {:positive => %w[strong adventurous brave],
                       :negative => ["can be arrogant at times"]},
                     
        :snake    =>  {:positive => %w[wise beautiful perfectionist],
                       :negative => ["sometimes suffers from self-doubt"]},      
                     
        :horse    =>  {:positive => %w[attractive popular intelligent],
                       :negative => %w[hot-tempered]},  
                     
        :goat     =>  {:positive => %w[artistic tender-hearted generous],
                       :negative => %w[indecisive]},
                     
        :monkey   =>  {:positive => %w[smart social charismatic],
                       :negative => ["can be arrogant at times"]},  
                     
        :rooster  =>  {:positive => %w[hard-working smart social],
                       :negative => ["not good at taking advice"]},
                     
        :dog      =>  {:positive => %w[loyal honest friendly],
                       :negative => ["easily criticizes others"]},
                     
        :pig      =>  {:positive => %w[honest social patient],
                       :negative => ["can be materialistic"]}         
                     
    }                          
  
    def self.attributes(animal, kind=:positive)
      # Old:
      # ATTRIBUTES.select { |x| x= animal} 
      # New:
      ATTRIBUTES[animal][kind]
    end
  end
  
  def first_attribute(kind=:positive)
    @first_attribute ||= Zodiac.attributes(zodiac, kind).first
  end
   
  # # If you haven't run across this yet, the ||= operator only does the calculation on the
  # # right side of the equation if the left side variable hadn't already been set. This saves
  # # Ruby from having to perform the Zodiac.for_birthdate call each time, and instead "caches"
  # # the result of the initial call to be used thereafter in the same "session."
  def zodiac
     @zodiac ||= Zodiac.for_birthdate(birthday)
  end
  
                        
  private
  
    def encrypt_password       
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(password)
    end
    
    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end          
    
    def make_salt
      secure_hash("#{Time.now.utc}--#{password}") 
    end
    
    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
end

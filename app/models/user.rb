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
  
  belongs_to :zodiac                  
                        
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
  # class Zodiac
  #   # The following date ranges are lifted from http://en.wikipedia.org/wiki/Chinese_zodiac
  #   TYPES = {
  #     :rat      => [%w(1924/2/5 1925/1/23),
  #                   %w(1936/1/24 1937/2/10)#,
  #                   # and more...
  #                   ],
  #     :ox       => [%w(1925/1/24 1926/2/12),
  #                   %w(1937/2/11 1938/1/30)
  #                   # and more...
  #                   ]#,
  #     # and more.
  #   }.freeze
  #   
  #   def self.for_birthdate(bdate)
  #     TYPES.detect do |animal, low_and_high|
  #       low, high = low_and_high.map { |date_str| Date.new(*date_str.split('/')) }
  #       (low..high).include?(bdate)
  #     end.first # because the result of detect looksl ike [ :rat, blahblah ]
  #     # result is the chinese zodiac animal name as a symbol, i.e. :rat
  #   end
  # end
  # 
  # # If you haven't run across this yet, the ||= operator only does the calculation on the
  # # right side of the equation if the left side variable hadn't already been set. This saves
  # # Ruby from having to perform the Zodiac.for_birthdate call each time, and instead "caches"
  # # the result of the initial call to be used thereafter in the same "session."
  # def zodiac
  #   @zodiac ||= Zodiac.for_birthdate(birthday)
  # end
  #
                        
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

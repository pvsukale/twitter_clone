class User < ApplicationRecord

    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :name , presence: true, length: { maximum: 50}
    validates :email, presence: true, length: {maximum: 255} , format: {with: VALID_EMAIL_REGEX}, uniqueness: { case_sensitive: false }
    validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
    attr_accessor :remember_token, :activation_token
     before_save   :downcase_email
     before_create :create_activation_digest
    
    has_secure_password
    
    
    def remember
        self.remember_token = User.new_token
        update_attribute(:remeber_digest, User.digest(remember_token))
    end

    def authenticated?(remember_token)
        return false if remeber_digest.nil?
        BCrypt::Password.new(remeber_digest).is_password?(remember_token)
    end

    def activate
         update_columns(activated: true, activated_at: Time.zone.now)
    end

    def send_activation_email
        UserMailer.account_activation(self).deliver_now
    end

    def authenticated_digest?(token)
        digest = self.activation_digest
        return false if digest.nil?
        BCrypt::Password.new(digest).is_password?(token)
        
    end

    def self.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
    end

    def self.new_token
        SecureRandom.urlsafe_base64
    end

    def forget
        update_attribute(:remeber_digest, nil)
    end

    def downcase_email
        self.email = email.downcase
      end
  
      # Creates and assigns the activation token and digest.
      def create_activation_digest
        self.activation_token  = User.new_token
        self.activation_digest = User.digest(activation_token)
      end
end
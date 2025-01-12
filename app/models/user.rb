class User < ApplicationRecord

  # Connects this user object to Blacklights Bookmarks.
  include Blacklight::User
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :timeoutable, :omniauthable, omniauth_providers: [:cas]

  # Method added by Blacklight; Blacklight uses #to_s on your
  # user class to get a user-displayable login/identifier for
  # the account.
  # def to_s
  #   email
  # end

  # def self.from_omniauth(auth)
  #   user = find_or_create_by(uid: auth.uid) do |u|
  #     u.email = auth.info.email
  #     u.name = auth.info.name || auth.uid
  #     u.password = Devise.friendly_token[0, 20]
  #   end
  #   user
  # end

  def self.from_omniauth(auth)
    find_or_create_by(provider: auth.provider, uid: auth.uid) do |user|
      # user.email = auth.info.email
      # user.password = Devise.friendly_token[0, 20]
      # user.name = auth.info.name # assuming the user model has a name
      # user.image = auth.info.image # assuming the user model has an image
      # If you are using confirmable and the provider(s) you use validate emails,
      # uncomment the line below to skip the confirmation emails.
      # user.skip_confirmation!
    end
  end
end

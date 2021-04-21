class User < ApplicationRecord
    before_save { self.name = name.downcase }
    has_secure_password
    validates :name, presence: true, length: { maximum: 50 }, uniqueness: { case_sensitive: false }
    validates :password_digest, presence: true
end

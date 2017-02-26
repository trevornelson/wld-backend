class User < ApplicationRecord
	has_secure_password

	validates_presence_of :email, :first_name, :last_name, :password
end

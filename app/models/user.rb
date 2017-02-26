class User < ApplicationRecord
	has_secure_password

	before_save :downcase_email

	validates_presence_of :email, :first_name, :last_name, :password
	validates_uniqueness_of :email, case_sensitive: false
	validates_format_of :email, with: /@/

	def downcase_email
		self.email = self.email.delete(' ').downcase
	end
end

class User < ApplicationRecord
	has_secure_password

	before_save :downcase_email

	validates_presence_of :email, :first_name, :last_name, :password
	validates_uniqueness_of :email, case_sensitive: false
	validates_format_of :email, with: /@/

	has_many :values
	has_many :relationship_categories
	has_many :relationships
	has_many :habits
	has_many :habit_todos
	has_many :short_term_goals
	has_many :long_term_goals
	has_many :quarterly_todos
	has_many :daily_todos

	def downcase_email
		self.email = self.email.delete(' ').downcase
	end

	def as_json(options={})
		super(options.merge({ except: [:password_digest] }))
	end

end

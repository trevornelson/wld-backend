class User < ApplicationRecord
	has_secure_password

	after_create :generate_core_values
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

	def as_json(options={})
		super(options.merge({ except: [:password_digest] }))
	end

  def to_dashboard
    User.includes(
      :values,
      :long_term_goals,
      :quarterly_todos,
      :daily_todos,
      short_term_goals: :long_term_goal,
      relationship_categories: :relationships,
      habits: :habit_todos
    ).find(id).to_json(
      include: {
        values: {},
        long_term_goals: {},
        quarterly_todos: {},
        daily_todos: {},
        short_term_goals: {
          include: :long_term_goal
        },
        relationship_categories: {
          include: :relationships
        },
        habits: {
          include: :habit_todos
        }
      }
    )
  end

	private
		def generate_core_values
			3.times { values.create(content: '') }
		end

		def downcase_email
			self.email = self.email.delete(' ').downcase
		end

end

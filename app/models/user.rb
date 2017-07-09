class User < ApplicationRecord
	has_secure_password

	after_create :generate_core_values
	before_save :downcase_email

	validates_presence_of :email, :first_name, :last_name
  validates :password, presence: true,
                       confirmation: true,
                       on: :create
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
  has_many :affirmations
  has_many :visualizations

  has_many :recent_todos,
    -> { where(due_date: DateTime.now.beginning_of_week(start_day = :sunday)..DateTime.now.end_of_week(start_day = :sunday)).order(:due_date, :created_at) },
    class_name: "DailyTodo"

  has_many :active_habits,
    -> { where(active: true) },
    class_name: "Habit"

  def s3_bucket_key
    "uploads/#{id}/#{SecureRandom.uuid}"
  end

	def as_json(options={})
		super(options.merge({ except: [:password_digest] }))
	end

  def to_dashboard
    User.includes(
      :values,
      :long_term_goals,
      :quarterly_todos,
      :daily_todos,
      :habits,
      :habit_todos,
      :affirmations,
      :visualizations,
      short_term_goals: :long_term_goal,
      relationship_categories: :relationships,
    ).find(id).to_json(
      include: {
        values: {},
        long_term_goals: {},
        quarterly_todos: {},
        recent_todos: {},
        active_habits: {},
        habit_todos: {},
        affirmations: {},
        visualizations: {},
        short_term_goals: {
          include: :long_term_goal
        },
        relationship_categories: {
          include: :relationships
        },
      }
    )
  end

  def to_token
    {
      'id' => id,
      'first_name' => first_name,
      'last_name' => last_name,
      'email' => email,
    }
  end

	private
		def generate_core_values
			3.times { values.create(content: '') }
		end

		def downcase_email
			self.email = self.email.delete(' ').downcase
		end

end

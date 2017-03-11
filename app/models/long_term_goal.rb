class LongTermGoal < ApplicationRecord
  belongs_to :user
  has_many :short_term_goals
end

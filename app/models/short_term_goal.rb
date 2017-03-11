class ShortTermGoal < ApplicationRecord
  belongs_to :user
  belongs_to :long_term_goal, optional: true
end

class RelationshipCategory < ApplicationRecord
  belongs_to :user
  has_many :relationships
end

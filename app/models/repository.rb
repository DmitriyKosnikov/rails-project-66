class Repository < ApplicationRecord
  extend Enumerize

  belongs_to :user

  enumerize :language, in: [:ruby]

  validates :github_id, presence: true, uniqueness: true
end

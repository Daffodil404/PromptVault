class PromptVersion < ApplicationRecord
  belongs_to :prompt
  belongs_to :user

  validates: version_number, presence: true
  validates: content, presence: true
end

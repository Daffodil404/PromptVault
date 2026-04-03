class PromptVersion < ApplicationRecord
  belongs_to :prompt
  belongs_to :user
end

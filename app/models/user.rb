class User < ApplicationRecord
    has_many :prompts, dependent: :destroy
    has_many :reviews, dependent: :destroy
    has_many :prompt_versions, dependent: :destroy

    validates: username, presence: true
    validates: email, presence: true, uniqueness: true
    validates: role, presence: true
end

class Question < ApplicationRecord
  belongs_to :template
  serialize :options, Array

  validates :text, presence: true
  validates :question_type, inclusion: { in: %w[text radio] }
end

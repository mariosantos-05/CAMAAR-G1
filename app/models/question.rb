class Question < ApplicationRecord
  belongs_to :template

  # options é ARRAY no banco (via JSON)
  attribute :options, :json, default: []

  validates :text, presence: true
  validates :question_type, inclusion: { in: %w[text radio] }


  def options=(value)
    if value.is_a?(String)
      super(value.split(",").map(&:strip))
    elsif value.nil?
      super([])
    else
      super(value)
    end
  end
end

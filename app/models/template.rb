class Template < ApplicationRecord
  belongs_to :criado_por, class_name: 'Usuario'
  has_many :forms, dependent: :restrict_with_error
  has_many :questions, dependent: :destroy

  accepts_nested_attributes_for :questions, allow_destroy: true

  validates :titulo, presence: { message: "O campo Título é obrigatório" }
  validates :titulo, format: { 
    with: /\A[a-zA-Z0-9\s\-\.]+\z/,
    message: "Formato de título inválido"
  }

  validate :must_have_questions

  private

  def must_have_questions
    if questions.reject(&:marked_for_destruction?).empty?
      errors.add(:base, "O template deve conter pelo menos uma questão")
    end
  end
end

##
# = Template Model
#
# Representa a estrutura base de uma avaliação (questionário).
# Um template contém um título, público-alvo e uma coleção de questões.
#
# == Associações
#
# * +belongs_to :criado_por+ (Usuario): O administrador que criou o template.
# * +has_many :forms+: Formulários gerados a partir deste template (Restringe deleção se existirem forms).
# * +has_many :questions+: Questões associadas ao template (Deleção em cascata).
#
# == Validações
#
# * +titulo+: Obrigatório e deve conter apenas caracteres alfanuméricos, espaços, hífens ou pontos.
# * +questions+: Deve conter pelo menos uma questão válida.
#
class Template < ApplicationRecord
  belongs_to :criado_por, class_name: "Usuario", optional: true
  has_many :forms, dependent: :restrict_with_error

  has_many :questions, dependent: :destroy

  accepts_nested_attributes_for :questions, allow_destroy: true, reject_if: :all_blank

  validates :titulo, presence: { message: "O campo Título é obrigatório" }
  validates :titulo, format: {
    with: /\A[a-zA-Z0-9\s\-\.]+\z/,
    message: "Formato de título inválido"
  }, allow_blank: true

  validate :must_have_questions

  private

  ##
  # Validação customizada para garantir que o template não seja salvo sem questões.
  # Ignora questões marcadas para destruição.
  def must_have_questions
    if questions.reject(&:marked_for_destruction?).empty?
      errors.add(:base, "O template deve conter pelo menos uma questão")
    end
  end
end

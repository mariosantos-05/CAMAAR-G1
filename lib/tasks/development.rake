namespace :dev do
  desc "Cria ou reseta o template de teste para formulários"
  task criar_template: :environment do
    unless Rails.env.development?
      puts "Essa task só deve ser executada em development!"
      next
    end

    # Garante que existe pelo menos um usuário
    usuario = Usuario.first || FactoryBot.create(:usuario)

    # Deleta o template de teste existente
    template = Template.find_by(titulo: "Template de Avaliação Temporário")
    template.destroy if template

    # Cria o template de teste
    template = FactoryBot.create(
      :template,
      titulo: "Template de Avaliação Temporário",
      criado_por: usuario
    )

    puts "Template de teste criado com sucesso!"
    puts "ID: #{template.id}, Título: #{template.titulo}, Criado por: #{template.criado_por.nome}"
  end
end

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# db/seeds.rb

puts "Criando usuário Admin..."

# Cria o Admin apenas se ele não existir
Usuario.find_or_create_by!(matricula: 'admin') do |u|
  u.nome = "Administrador do Sistema"
  u.email = "admin@camaar.unb.br"
  u.password = "Admin123" # Precisa atender ao regex (Maiúscula, minúscula, número)
  u.password_confirmation = "Admin123"
  u.profile = "Admin"     # Perfil exato que o controller verifica
  u.status = true         # status: true para pular a etapa de Primeiro Acesso
  u.departamento_id = 1   # ID fictício, já que ainda não temos tabela de departamentos
end

puts "Admin criado com sucesso!"
puts "Login: admin (ou admin@camaar.unb.br)"
puts "Senha: Admin123"

class ApplicationController < ActionController::Base
  helper_method :current_user
  allow_browser versions: :modern


  #This whole section is to mock user authentication for development/testing purposes.
  def current_user
    fake_role = ENV["FAKE_ROLE"] || "admin"   #default to admin

    case fake_role
    when "admin"
      Usuario.find_or_create_by(profile: "Admin") do |u|
        u.nome = "Fake Admin"
        u.email = "admin@test.com"
        u.matricula = "000"
        u.status = true
        u.departamento_id = 1
      end
    when "user"
      Usuario.find_or_create_by(profile: "User") do |u|
        u.nome = "Fake User"
        u.email = "user@test.com"
        u.matricula = "111"
        u.status = true
        u.departamento_id = 1
      end
    else
      nil
    end
  end
end

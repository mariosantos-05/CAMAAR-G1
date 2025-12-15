require "rails_helper"

RSpec.describe Form, type: :model do
  it "cria form com template e turma" do
    usuario = create(:admin)
    template = create(:template, criado_por: usuario)
    turma = create(:turma)

    form = create(:form, template: template, turma: turma, is_active: true)

    expect(form).to be_persisted
    expect(form.template).to eq(template)
    expect(form.turma).to eq(turma)
  end
end

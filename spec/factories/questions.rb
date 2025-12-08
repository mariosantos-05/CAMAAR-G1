FactoryBot.define do
  factory :question do
    template { nil }
    text { "MyString" }
    question_type { "MyString" }
    options { "MyText" }
  end
end

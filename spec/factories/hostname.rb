FactoryBot.define do
  factory :hostname, class: Hostname do
    address { Faker::Internet.domain_name }
  end
end
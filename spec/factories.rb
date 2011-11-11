FactoryGirl.define do
  factory :investment do
    sequence(:name, 1) { |i| "#{i} new ventilators" }
    sequence(:cost, 1) { |i| i*100}
    association(:organization)
  end

  factory :organization do
    sequence(:name) { |i| "Company level #{i}" }
  end
end

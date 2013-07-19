FactoryGirl.define do

  factory :map do
    sequence(:name){ |n| "pl_test_map_b#{n}"}
    map_type
  end

  factory :map_type do
    name "Payload"
    prefix "pl"
  end

  factory :map_comment do
    comment "Foo bar baz."
    user
  end

  factory :user do
    nickname "FooBar"
  end
end

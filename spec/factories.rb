FactoryGirl.define do

  factory :map do
    name "pl_test_map_b1"
    map_type
  end

  factory :map_type do
    name "Payload"
    prefix "pl"
  end

  factory :user do
    nickname "FooBar"
    uid "12345"
    provider "steam"
  end

  factory :map_comment do
    comment "Foo bar baz."
    user
    map
  end
end

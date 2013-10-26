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
    sequence :uid do |n|
      "123#{n}"
    end
    provider "steam"

    factory :admin do
      admin true
    end
    factory :moderator do
      moderator true
    end
    factory :banned do
      banned_at Time.now
    end
  end

  factory :map_comment do
    comment "Foo bar baz."
    user
    map
  end

  factory :vote do
    value 0
    user
    map
  end

  factory :map_favorite do
    user
    map
  end

  factory :api_key do
    name "Test Server"
  end
end

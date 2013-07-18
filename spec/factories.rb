Factory.define :map do |f|
  f.name "cp_test_b1"
end
Factory.define :user do |f|
  f.nickname "foo"
  f.avatar_url "http://example.com/foo"
end
Factory.define :map_comment do |f|
  f.comment "Foo bar baz."
  f.association :map
  f.association :user
end

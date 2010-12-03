Factory.define :page_a, :class => PageA do |node|
  node.title { Faker::Lorem.words(3).join(' ') }
  node.body { Faker::Lorem.paragraphs(6) }
  node.published_at { Time.now }
end
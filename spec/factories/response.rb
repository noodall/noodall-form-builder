FactoryGirl.define do
  factory :response, :class => Noodall::FormResponse do |response|
    response.name "A User"
    response.email "user@example.com"
    response.ip "127.0.0.1"
    response.created_at Time.zone.now
    response.referrer "http://rac.local/the-college"
  end
end

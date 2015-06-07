FactoryGirl.define do
  factory :cruise do
    name "Name"
    description "MyText"
    ship
    start_at "2015-06-07 10:23:31"
    end_at "2015-06-17 10:23:31"
  end

end

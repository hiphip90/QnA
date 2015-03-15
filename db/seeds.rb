# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
10.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@example.com"
  User.create!(name: name, email: email)
end

User.all.each do |user|
  title = Faker::Lorem.sentence(6)
  body = Faker::Lorem.paragraph(4)
  user.questions.create!(title: title, body: body)
end

Question.all.each do |question|
  User.all.each do |user|
    body = Faker::Lorem.sentence(6)
    question.answers.create!(body: body, user_id: user.id)
  end
end

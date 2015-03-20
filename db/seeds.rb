# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
10.times do
  name = Faker::Name.name
  email = Faker::Internet.email
  User.create(name: name, email: email, password: 'password', password_confirmation: 'password')

  title = Faker::Lorem.sentence(6)
  body = Faker::Lorem.paragraph(2)
  Question.create(title: title, body: body, user: User.last)
end

Question.find_each do |question|
  User.find_each do |user|
    question.answers.create(body: Faker::Lorem.sentence(6), user: user)
  end
end

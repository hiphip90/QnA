# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
10.times do |n|
  title = Faker::Lorem.sentence(6)
  body = Faker::Lorem.paragraph(4)
  Question.create!(title: title, body: body)
end

Question.all.each do |question|
  10.times do
    body = Faker::Lorem.sentence(6)
    question.answers.create!(body: body)
  end
end

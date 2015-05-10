json.extract! @question, :title, :body, :user_id
json.link question_url(@question)

json.user do
  json.name @question.user.name
end

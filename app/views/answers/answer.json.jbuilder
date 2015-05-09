json.extract! @answer, :id, :question_id, :body, :created_at, :updated_at, :user_id, :rating
json.url answer_url(@answer)
json.accept_url accept_answer_url(@answer)

json.attachments @answer.attachments do |attachment|
  json.id attachment.id
  json.file_name attachment.file.identifier
  json.file_url attachment.file.url
end
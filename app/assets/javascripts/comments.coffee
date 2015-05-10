$ -> 
  questionId = $('.question').data('questionId');

  $('.new-question-comment-link').click (e) ->
    e.preventDefault()
    $('.question-comment-form').show();

  $('.new-answer-comment-link').click (e) ->
    e.preventDefault()
    answer = $(this).parents('li');
    answer.find('.answer-comment-form').show();

  # process new comment creation
  Danthes.subscribe "/questions/#{questionId}/comments", (data, channel) -> 
    comment = $.parseJSON(data.comment);
    if comment.commentable_type == 'Answer'
      target = $("#answer_#{comment.commentable_id}")
    else
      target = $('.question');
    target.find('.comment-errors').remove();
    target.find('.comments-block').append(JST["templates/_comment"]({ comment: comment }));
    target.find('#new_comment textarea').val('');

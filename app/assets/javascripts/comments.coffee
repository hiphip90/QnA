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
      answer = $("#answer_#{comment.commentable_id}")
      answer.find('.comment-errors').remove()
      answer.find('.comments-block').append(JST["templates/_comment"]({ comment: comment }));
      $('#new_comment textarea').val('');
    else
      $('.question .comment-errors').remove();
      $('.question .comments-block').append(JST["templates/_comment"]({ comment: comment }));
      $('#new_comment textarea').val('');

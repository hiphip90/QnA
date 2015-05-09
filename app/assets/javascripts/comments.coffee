$ -> 
  questionId = $('.question').data('questionId');

  $('.new-question-comment-link').click (e) ->
    $('.question-comment-form').show();

  # process new comment creation
  Danthes.subscribe "/questions/#{questionId}/comments", (data, channel) -> 
    comment = $.parseJSON(data.comment);
    $('.comment-errors').remove();
    $('.comments-block').append(JST["templates/_comment"]({ comment: comment }));
    $('#new_comment textarea').val('');

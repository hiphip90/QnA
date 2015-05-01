# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  # show edit form 
  $(document).on "click", ".edit-answer", (e) -> 
    e.preventDefault()
    answer = $(this).parents("li")
    answer.find(".answer-body").hide();
    answer.find(".edit-answer-form").show();

  # discard edit and hide form
  $(document).on "click", ".discard", (e) ->
    answer = $(this).parents("li")
    answer.find(".answer-body").show();
    answer.find(".edit-answer-form").hide();
    answer.find(".answer-errors").remove();
    answer.find("textarea").val(answer.find('span').text())

  # process new answer creation
  $('#new_answer').bind 'ajax:success', (e, data, status, xhr) ->
    answer = $.parseJSON(xhr.responseText);
    $('.answers').show();
    $('.answers-block').append(JST["templates/_answer"]({ answer: answer }));
    $('.answer-errors').remove();
    $('#new_answer textarea').val('');
    $('#new_answer .nested-fields').not(':first-child').remove();
  .bind 'ajax:error', (e, xhr, status, error) ->
    errors = $.parseJSON(xhr.responseText);
    $('.answer-errors').remove();
    for error in errors 
      $('#new_answer').before('<p class="answer-errors">' + error + '</p>')

  # process answer editing
  $(document).on 'ajax:success', '.edit_answer', (e, data, status, xhr) ->
    answer = $.parseJSON(xhr.responseText);
    $("#answer_#{answer.id}").replaceWith(JST["templates/_answer"]({ answer: answer }));
  .bind 'ajax:error', (e, xhr, status, error) ->
    errors = $.parseJSON(xhr.responseText);
    $('.answer-errors').remove();
    for error in errors 
      $(e.target).before('<p class="answer-errors">' + error + '</p>');

  # process answer voting
  $(document).on 'ajax:success', '.upvote-link, .downvote-link', (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText);
    answer = $("#answer_#{response.id}");
    answer.find('.rating').text(response.rating);
    answer.find('.upvote-link, .downvote-link').hide();
    answer.find('.recall-vote').show();

  $(document).on 'ajax:success', '.recall-vote', (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText);
    answer = $("#answer_#{response.id}");
    answer.find('.rating').text(response.rating);
    answer.find('.upvote-link, .downvote-link').show();
    answer.find('.recall-vote').hide();
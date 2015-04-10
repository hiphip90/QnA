# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  # show edit form 
  $(document).on "click", ".edit-question-link", (e) -> 
    e.preventDefault()
    $(".show-question-block").hide();
    $(".edit-question-form").show();

  # discard edit and hide form
  $(document).on "click", ".question-discard", (e) ->
    $(".show-question-block").show();
    $(".edit-question-form").hide();
    $("#question_title").val($('.page-header').text());
    $("#question_body").val($('.question-body').text())


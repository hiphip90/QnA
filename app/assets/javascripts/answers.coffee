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
    answer.find("#error_explanation").remove();
    answer.find("#answer_body").val(answer.find('span').text())

# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  # show edit form 
  $(".edit-answer").on "click", (e) -> 
    e.preventDefault()
    answer = $(this).parents("li")
    answer.find(".answer-body").addClass('conceal')
    answer.find(".edit-answer-form").removeClass('conceal')

  # discard edit and hide form
  $(".discard, .submit").click ->
    answer = $(this).parents("li")
    answer.find(".answer-body").removeClass('conceal')
    answer.find(".edit-answer-form").addClass('conceal')

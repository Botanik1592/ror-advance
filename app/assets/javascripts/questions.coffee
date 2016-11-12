# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('.edit-question-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    question_id = $(this).data('questionId')
    $('form#edit-question-' + question_id).show();

  $('.rateup').on 'ajax:success', (e, data, status, xhr) ->
    id = $(this).data('targetId');
    rating = $.parseJSON(xhr.responseText);
    $('#question-rating-' + id).html(rating.show_rate);
    $('#question-rateup-' + id).attr('disabled', true);
    $('#question-ratedown-' + id).attr('disabled', false);

  $('.ratedown').on 'ajax:success', (e, data, status, xhr) ->
    id = $(this).data('targetId');
    rating = $.parseJSON(xhr.responseText);
    $('#question-rating-' + id).html(rating.show_rate);
    $('#question-ratedown-' + id).attr('disabled', true);
    $('#question-rateup-' + id).attr('disabled', false);

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)
$(document).on("turbolinks:load", ready)

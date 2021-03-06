# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('.edit-answer-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('answerId')
    $('#edited-answer-' + answer_id).hide();
    $('form#edit-answer-' + answer_id).show();

  $('.rateup').on 'ajax:success', (e, data, status, xhr) ->
    id = $(this).data('targetId');
    rating = $.parseJSON(xhr.responseText);
    $('#answer-rating-' + id).html(rating.show_rate);
    $('#answer-rateup-' + id).attr('disabled', true);
    $('#answer-ratedown-' + id).attr('disabled', false);

  $('.ratedown').on 'ajax:success', (e, data, status, xhr) ->
    id = $(this).data('targetId');
    rating = $.parseJSON(xhr.responseText);
    $('#answer-rating-' + id).html(rating.show_rate);
    $('#answer-ratedown-' + id).attr('disabled', true);
    $('#answer-rateup-' + id).attr('disabled', false);

  $('.ratelink').on 'ajax:error', (e, xhr, status, error) ->
    id = $(this).data('targetId');
    if status == 'error'
      error_message = "You can't rate this answer";
      $('#answer-set-rating-error-' + id).html(error_message);
    else
      message = $.parseJSON(xhr.responseText);
      error_message = message.error;
      $('#answer-set-rating-error-' + id).htmlhtml('<b>'+error_message+'</b>');

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)
$(document).on("turbolinks:load", ready)

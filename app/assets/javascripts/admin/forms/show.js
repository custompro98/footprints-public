$(function() {
  $('.add-field-link').click(addFieldTemplate);
  $('.add-answer-link').click(addAnswerTemplate);
  $('.delete-field-btn').click(deleteField);
  $('.delete-answer-btn').click(deleteAnswer);
  $('input[type=text]').focusout(submitForm);
})

function addFieldTemplate(e) {
  var fieldNumber = $('.js-field').length;

  $.ajax({
    type: 'GET',
    url: '/admin/field?field_number=' + fieldNumber,
    async: true,
    success: function(response) {
      $('.field-list').append(response.html);
      $('.add-field-link').off('click').on('click', addFieldTemplate);
      $('.add-answer-link').off('click').on('click', addAnswerTemplate);
      $('.delete-btn').off('click').on('click', deleteField);
      $('input[type=text]').off('focusout').on('focusout', submitForm);
    }
  });
}

function addAnswerTemplate(e) {
  var fieldNumber = $(e.target).data('field-index');
  var answerList = $(this).siblings('.answer-list')
  var fieldChoiceNumber = answerList.find('input').length;

  $.ajax({
    type: 'GET',
    url: '/admin/field_choice?field_number=' + fieldNumber + '&field_choice_number=' + fieldChoiceNumber,
    async: true,
    success: function(response) {
      $(answerList).append(response.html);
      $('.add-answer-link').off('click').on('click', addAnswerTemplate);
      $('.delete-answer-btn').click(deleteAnswer);
      $('input[type=text]').off('focusout').on('focusout', submitForm);
    }
  });
}

function submitForm() {
  $('input[type=submit]').click();
}

function deleteField(e) {
  $(e.target).parents('.field_answer_card_box').remove();
  submitForm();
}

function deleteAnswer(e) {
  $(e.target).parents('.answer-block').remove();
  submitForm();
}

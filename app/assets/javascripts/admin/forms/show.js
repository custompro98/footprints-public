$(function() {
  $('.add-field-link').click(addFieldTemplate);
  $('.add-answer-link').click(addAnswerTemplate)
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
    }
  });
}


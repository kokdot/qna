$(document).on('turbolinks:load',function(){
  $('.answers').on('click', '.edit-answer-link', function(e){
    e.preventDefault();
    $(this).hide();
    var answerId = $(this).data('answerId');
    $('form#edit-answer-' + answerId).removeClass('hidden');
  })
  $('.answers').on('click', '.save-answer-link', function(e){
    var answerId = $(this).data('answerId');
    $('div.answer-' + answerId).hide();
  })
  $('.edit-question').on('click', '.edit-question-link', function(e){
    e.preventDefault();
    $(this).hide();
    $('.edit-question form').removeClass('hidden');
  })
});
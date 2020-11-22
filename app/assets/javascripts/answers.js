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
  $('.question_vote a.new-vote').on('ajax:success', function(e) {
    $('.question_vote p.rating-error').html('');
    var rating = e.detail[0];
    $('.question_vote p.rating').html('Rating:' + rating.sum );
  })
  .on('ajax:error', function (e) {
    $('.question_vote p.rating-error').html('');
    var mes = e.detail[0];
    $('.question_vote p.rating-error').html('<p>' + mes.mes + '</p>');
  })
  $('.question_vote a.cancel-vote').on('ajax:success', function(e) {
    $('.question_vote p.rating-error').html('');
    var rating = e.detail[0];
    $('.question_vote p.rating').html('Rating:' + rating.sum );
  })
  .on('ajax:error', function (e) {
    $('.question_vote p.rating-error').html('');
    $('.question_vote p.rating-error').html('<p>' + ' You do not vote' + '</p>');
  })
  $('.answers a.new-vote').on('ajax:success', function(e) {
    var answerId = $(this).data('answerId');
    $('.'+'answer-'+answerId+' p.rating-error').html('');
    var rating = e.detail[0];
    $('.'+'answer-'+answerId+' p.rating').html('Rating:' + rating.sum );
  })
  .on('ajax:error', function (e) {
    var answerId = $(this).data('answerId');
    $('.'+'answer-'+answerId+' p.rating-error').html('');
    var mes = e.detail[0];
    $('.'+'answer-'+answerId+' p.rating-error').html('<p>' + mes.mes + '</p>');
  })
  $('.answers a.cancel-vote').on('ajax:success', function(e) {
    var answerId = $(this).data('answerId');
    $('.'+'answer-'+answerId+' p.rating-error').html('');
    var rating = e.detail[0];
    $('.'+'answer-'+answerId+' p.rating').html('Rating:' + rating.sum );
  })
  .on('ajax:error', function (e) {
    var answerId = $(this).data('answerId');
    $('.'+'answer-'+answerId+' p.rating-error').html('');
    $('.'+'answer-'+answerId+' p.rating-error').html('<p>' + ' You do not vote' + '</p>');
  }) 
});

$(document).on("turbolinks:load", function () {
  if (/questions\/\d+/.test(window.location.pathname)) {
    App.cable.subscriptions.create(
      { channel: "AnswerChannel", question_id: gon.question_id }, {
      connected: function () {
        // console.log("Answer Connected!");
      },
      received: function (data) {
        if (data.type === 'answer') {
          // console.log('RECIEVE DATA', data);
          // нужно определить is_file_attached
          data.is_file_attached = data.files.length;
          // нужно определить is_link_attached
          data.is_link_attached = data.links.length;
          // нужно определить is_answer_owner
          data.is_answer_owner = gon.user_id === data.answer.user_id;
          data.is_not_answer_owner = !(gon.user_id === data.answer.user_id);
          // нужно определить is_question_owner
          data.is_question_owner = gon.user_id === gon.question_owner_id;
          $('.answers').append(
            HandlebarsTemplates['answer'](data)
            );
          $('textarea#answer_body').val('')
          } else {
            if (data.resource === 'Question') {
              // console.log('RECIEVE DATA FOR Question', data);
              $('.question-comments').append(
                HandlebarsTemplates['comment'](data)
                );
              } else {
                // console.log('RECIEVE DATA FOR Answer', data);
                $('.answer-comments').append(
                  HandlebarsTemplates['comment'](data)
                  );
              }
          }
        }
      });
    } else {
      App.cable.subscriptions.create(
        "QuestionChannel", {
        connected: function () {
          // console.log("Question Connected!");
        },
        received: function (data) {
          // console.log('RECIEVE DATA', data);
          $('.question-list').append(
            HandlebarsTemplates['question'](data)
          );
        },
      }
    );
  }
});

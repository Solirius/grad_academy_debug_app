FactoryBot.define do
  factory :answer do
    user
    answer {
      {
        question__page_1: [
          I18n.t('quiz_form.question_page_1.question_1.answer_1'),
          I18n.t('quiz_form.question_page_1.question_2.answer_1'),
          I18n.t('quiz_form.question_page_1.question_3.answer_1'),
          I18n.t('quiz_form.question_page_1.question_4.answer_1'),
          I18n.t('quiz_form.question_page_1.question_5.answer_1')
        ],
        question_page_2: [
          I18n.t('quiz_form.question_page_2.question_1.answer_1'),
          I18n.t('quiz_form.question_page_2.question_2.answer_1'),
          I18n.t('quiz_form.question_page_2.question_3.answer_1'),
          I18n.t('quiz_form.question_page_2.question_4.answer_1'),
          I18n.t('quiz_form.question_page_2.question_5.answer_1')
        ],
        question_page_3: [
          I18n.t('quiz_form.question_page_3.question_1.correct_answer'),
          I18n.t('quiz_form.question_page_3.question_2.correct_answer'),
          I18n.t('quiz_form.question_page_3.question_3.correct_answer'),
          I18n.t('quiz_form.question_page_3.question_4.correct_answer'),
          I18n.t('quiz_form.question_page_3.question_5.correct_answer')
        ]
      }
    }
    date_attempted { '2024-02-28 09:02:48' }
    completed { false }
    score { rand(60..100) }
  end
end

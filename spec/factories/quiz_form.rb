FactoryBot.define do
  factory :quiz_form do
    transient do
      user { FactoryBot.create(:user) }
    end

    answer_1 { I18n.t('quiz_form.question_page_1.question_1.answer_1') }
    answer_2 { I18n.t('quiz_form.question_page_1.question_1.answer_1') }
    answer_3 { I18n.t('quiz_form.question_page_1.question_1.answer_1') }
    answer_4 { I18n.t('quiz_form.question_page_1.question_1.answer_1') }
    answer_5 { I18n.t('quiz_form.question_page_1.question_1.answer_1') }

    answer {
      {
        question_1: [
          I18n.t('quiz_form.question_page_1.question_1.answer_1'),
          I18n.t('quiz_form.question_page_1.question_2.answer_1'),
          I18n.t('quiz_form.question_page_1.question_3.answer_1'),
          I18n.t('quiz_form.question_page_1.question_4.answer_1'),
          I18n.t('quiz_form.question_page_1.question_5.answer_1')
        ],
        question_2: [
          I18n.t('quiz_form.question_page_2.question_1.answer_1'),
          I18n.t('quiz_form.question_page_2.question_2.answer_1'),
          I18n.t('quiz_form.question_page_2.question_3.answer_1'),
          I18n.t('quiz_form.question_page_2.question_4.answer_1'),
          I18n.t('quiz_form.question_page_2.question_5.answer_1')
        ],
        question_3: [
          I18n.t('quiz_form.question_page_3.question_1.correct_answer'),
          I18n.t('quiz_form.question_page_3.question_2.correct_answer'),
          I18n.t('quiz_form.question_page_3.question_3.correct_answer'),
          I18n.t('quiz_form.question_page_3.question_4.correct_answer'),
          I18n.t('quiz_form.question_page_3.question_5.correct_answer')
        ]
      }
    }
    current_step { 1 }
    current_user_id { user.id }

    trait :with_nil_answers do
      answer_1 { nil }
      answer_2 { nil }
      answer_3 { nil }
      answer_4 { nil }
      answer_5 { nil }

      answer {
        {
          question_1: [nil, nil, nil, nil, nil],
          question_2: [nil, nil, nil, nil, nil],
          question_3: [nil, nil, nil, nil, nil]
        }
      }
    end
  end
end

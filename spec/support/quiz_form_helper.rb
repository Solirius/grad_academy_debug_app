module QuizFormHelpers
  def generate_quiz_form_params(answer_values)
    {
      answer_1: answer_values[0],
      answer_2: answer_values[1],
      answer_3: answer_values[2],
      answer_4: answer_values[3],
      answer_5: answer_values[4],
      current_step: 1,
      answer: [],
      current_user_id: user.id
    }
  end

  def generate_randomized_quiz_form_params
    answer_values = Array.new(5) { Faker::Lorem.word }
    generate_quiz_form_params(answer_values)
  end

  def encode_quiz_form_params(params)
    UrlParamsEncoder.encode(params)
  end

  def quiz_form_hash
    {
      'current_step' => '1',
      'answer_1' => 'Femur',
      'answer_2' => 'Isaac Newton',
      'answer_3' => 'IBM',
      'answer_4' => 'Mount Kilimanjaro',
      'answer_5' => 'Oxygen'
    }
  end
end

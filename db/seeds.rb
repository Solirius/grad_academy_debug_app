# Function to calculate total correct answers and total questions attempted based on correct answers in en.yml
def total_correct_answers(_user, answers)
  correct_answers = YAML.load_file(Rails.root.join('config/locales/en.yml'))['en']['quiz_form']

  total_correct = 0
  total_questions = 0

  answers.each do |page_key, answer_list|
    # Ensure page_key is treated as a string
    page_key = page_key.to_s if page_key.is_a?(Symbol)

    # Extract page_index from page_key
    page_index = page_key.split('_').last.to_i - 1

    answer_list.each_with_index do |user_answer, question_index|
      correct_answer_key = "question_page_#{page_index + 1}.question_#{question_index + 1}.correct_answer"

      # Traverse correct_answers hash to reach the correct answer
      correct_answer = traverse_correct_answers(correct_answers, correct_answer_key)

      if correct_answer
        total_questions += 1
        total_correct += 1 if user_answer.downcase == correct_answer.downcase
      end
    end
  end

  [total_correct, total_questions]
end

# Helper method to traverse correct_answers hash based on the provided key
def traverse_correct_answers(hash, key)
  keys = key.split('.')
  keys.each do |k|
    return nil unless hash && hash[k]

    hash = hash[k]
  end
  hash.to_s.downcase
end

# Define sample users
users_data = [
  { email: 'test@test.com', username: 'test', password: 'test' },
  { email: 'alice@example.com', username: 'alice', password: 'password' },
  { email: 'bob@example.com', username: 'bob', password: 'password' },
  { email: 'charlie@example.com', username: 'charlie', password: 'password' }
]

# Create users if they don't already exist
users_data.each do |user_data|
  user = User.find_or_create_by(email: user_data[:email]) do |new_user|
    new_user.username = user_data[:username]
    new_user.password = user_data[:password]
  end

  if user.persisted?
    puts "Created user: #{user.username}"
  else
    puts "User #{user.username} already exists."
  end
end

# Define example answers for each user
answers_data = {
  'test' => {
    question_page_1: ['Tibia', 'Isaac Newton', 'Intel', 'Mount Everest', 'Nitrogen'],
    question_page_2: ['Photosynthesis', 'Ornithology', 'Dorothy Hodgkin', 'Ruby', 'F. Scott Fitzgerald'],
    question_page_3: %w[giraffe pacific lima au ruby]
  },
  'alice' => {
    question_page_1: ['Tibia', 'Isaac Newton', 'Intel', 'Mount Everest', 'Nitrogen'],
    question_page_2: ['Photosynthesis', 'Entomology', 'Dorothy Hodgkin', 'Python', 'J.D. Salinger'],
    question_page_3: %w[giraffe pacific lima au ruby]
  },
  'bob' => {
    question_page_1: ['Femur', 'Albert Einstein', 'Intel', 'Mount Everest', 'Nitrogen'],
    question_page_2: ['Photosynthesis', 'Ichthyology', 'Marie Curie', 'Python', 'J.D. Salinger'],
    question_page_3: %w[giraffe pacific lima au ruby]
  },
  'charlie' => {
    question_page_1: ['Tibia', 'Albert Einstein', 'Intel', 'Mount Everest', 'Nitrogen'],
    question_page_2: ['Photosynthesis', 'Entomology', 'Rosalind Franklin', 'Python', 'J.D. Salinger'],
    question_page_3: %w[shark pacific lima pb ruby]
  }
}

# Create answers for each user if they don't already exist
answers_data.each do |username, answers|
  user = User.find_by(username:)

  if user
    if user.answers.exists?
      puts "Answers for user #{user.username} already exist."
    else
      total_correct, total_questions = total_correct_answers(user, answers)

      # Calculate score as a percentage
      score_percentage = total_questions.positive? ? (total_correct.to_f / total_questions * 100).round(2) : 0.0

      Answer.create!(
        user:,
        answer: answers,
        date_attempted: Time.zone.today,
        completed: true,
        score: score_percentage
      )
      puts "Created answers for user: #{user.username}, Score: #{score_percentage}%"
    end
  else
    puts "User #{username} not found."
  end
end

puts 'Seed data created successfully!'

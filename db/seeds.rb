# Include QuizResultsHelper to access helper methods
include QuizResultsHelper

# Define sample users (assuming User model exists)
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
  user = User.find_by(username: username)

  if user
    if user.answers.exists?
      puts "Answers for user #{user.username} already exist."
    else
      # Create an instance of Answer
      answer = Answer.create!(
        user: user,
        answer: answers,
        date_attempted: Time.zone.today,
        completed: true
      )

      # Use the created answer object for scoring and other operations
      quiz_results = answer

      score_percentage = score_percentage(quiz_results) || 0

      answer.update(score: score_percentage)

      puts "Created answers for user: #{user.username}, Score: #{score_percentage}%"
    end
  else
    puts "User #{username} not found."
  end
end

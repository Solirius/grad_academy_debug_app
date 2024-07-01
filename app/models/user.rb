# User represents a registered user of the application.
#
# It includes functionalities for authentication and associations with answers
# submitted in quizzes.
#
# Attributes:
#   - email: Must be present, formatted as a valid email address, and unique across users.
#   - username: Must be present, serving as the unique identifier for the user.
#
# Associations:
#   - has_many :answers: Represents the answers submitted by the user in quizzes.
#     These answers are dependent on the user and will be destroyed if the user is deleted.
#
# Validations:
#   - email: Presence and format validation using URI::MailTo::EMAIL_REGEXP, ensuring uniqueness.
#   - username: Presence validation, ensuring each user has a username.
#
# Security:
#   - has_secure_password: Provides password encryption and validation capabilities.
#
# Note: User models are crucial for managing user authentication and tracking user activities
#       such as quiz participation and results.
class User < ApplicationRecord
  has_secure_password
  has_many :answers, dependent: :destroy

  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: true
  validates :username, presence: true
end

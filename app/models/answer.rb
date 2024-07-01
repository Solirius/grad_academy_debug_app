# Represents the user's answers for a quiz attempt.
#
# An `Answer` instance stores:
#
# - `answer_1` through `answer_5`: Individual answers per page number of the quiz.
# - `answer`: Serialized 2D array that holds all answers for each page of the quiz.
#
# Example structure of `answer`:
#   answer = [
#     question_page_1: ['a', 'b', 'c', 'd', 'a'],
#     question_page_2: ['a', 'b', 'c', 'd', 'a'],
#     question_page_3: ['a', 'b', 'c', 'd', 'a'],
#     question_page_4: ['a', 'b', 'c', 'd', 'a'],
#     question_page_5: ['a', 'b', 'c', 'd', 'a']
#   ]
#
# Associations:
# - `belongs_to :user`: Specifies the user who attempted the quiz.
#
# Serializes `answer` using JSON for storage in the database.
#
# Validations:
# - `presence` of `answer`: Ensures the answer data is present.
# - `presence` of `date_attempted`: Ensures the date of the quiz attempt is recorded.
# - `inclusion` of `completed`: Validates that `completed` is either true or false.
# - Custom validation `validate_answer`: Validates the format and completeness of `answer`.
#
# Private Methods:
# - `validate_answer`: Calls `validate_answer_format` to check if all questions have been answered.
# - `validate_answer_format`: Validates that each quiz attempt has exactly `QUESTIONS_PER_PAGE` answers.
#
# Uses `QuizConstantsHelper` for constants like `QUESTIONS_PER_PAGE`.
#
# Example Usage:
#   answer = Answer.new(user: current_user,
#                       answer: { question_page_1: ['a', 'b', 'c', 'd', 'a'] },
#                       date_attempted: Time.zone.today,
#                       completed: false)
#   answer.save
#
# Note: Adjust the `answer` structure as per your application's quiz requirements.
#
class Answer < ApplicationRecord
  include QuizConstantsHelper

  belongs_to :user

  serialize :answer, coder: JSON
  validates :answer, presence: { message: ->(_object, _data) { I18n.t('answers.errors.empty_answer') } }
  validates :date_attempted, presence: true
  validates :completed, inclusion: { in: [true, false] }

  validate :validate_answer, if: -> { answer.present? }

  private

  def validate_answer
    validate_answer_format
  end

  def validate_answer_format
    return if answer.values.last.length == QUESTIONS_PER_PAGE

    errors.add(:answer, I18n.t('answers.errors.unanswered_questions'))
  end
end

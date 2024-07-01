# StepsHelper provides helper methods for formatting and managing quiz steps.
#
module StepsHelper
  include QuizConstantsHelper

  # Formats the question to display its page number.
  #
  # Parameters:
  # - question: String representing the question identifier.
  #
  # Returns:
  # - String formatted as "Page X", where X is the page number extracted from the question.
  #
  def format_question(question)
    page_number = question.match(/(\d+)/)[0]
    "Page #{page_number}"
  end

  # Formats the quiz question text based on its internationalization key and index.
  #
  # Parameters:
  # - question: String representing the question identifier.
  # - index: Integer representing the question index within the page.
  #
  # Returns:
  # - String containing the formatted quiz question text.
  #
  def format_quiz_question(question, index)
    I18n.t("quiz_form.#{question}.question_#{index + 1}.question")
  end

  # Calculates the continuous index of a question across multiple quiz pages.
  #
  # Parameters:
  # - current_step: Current step or page number of the quiz.
  # - question_index: Index of the question within its current page.
  #
  # Returns:
  # - Integer representing the continuous index of the question.
  #
  def continuous_index(current_step, question_index)
    ((current_step.to_i - 1) * QUESTIONS_PER_PAGE) + question_index.to_i
  end

  # Generates validation error text for a specific question based on its index.
  #
  # Parameters:
  # - current_step: Current step or page number of the quiz.
  # - question_index: Index of the question within its current page.
  #
  # Returns:
  # - String containing the formatted validation error message.
  #
  def validation_error_text(current_step, question_index)
    "Question #{continuous_index(current_step, question_index)} : #{I18n.t('quiz_form.errors.blank_answer')}"
  end
end

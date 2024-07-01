# StepsConcern module provides methods for handling quiz form steps and parameters.
module StepsConcern
  extend ActiveSupport::Concern
  include QuizConstantsHelper

  # Retrieves and permits quiz form parameters, merging them with decoded params if encoded params are present.
  def quiz_form_params
    if check_for_encoded_params_and_quiz_form
      params[:quiz_form].permit!
      params[:quiz_form] = decoded_params.merge(params[:quiz_form])
    end

    params.require(:quiz_form).permit(:answer, :answer_1, :answer_2, :answer_3, :answer_4, :answer_5, :current_step)
  end

  # Builds a QuizForm instance from given form parameters.
  def build_quiz_form_from_params(form_params)
    QuizForm.new(form_params.merge(current_user_id: current_user.id))
  end

  # Builds a QuizForm instance from encoded parameters.
  def build_quiz_form_from_encoded_params
    QuizForm.new(decoded_params.merge(current_user_id: current_user.id))
  end

  # Builds a default QuizForm instance with current step and user information.
  def build_default_quiz_form
    QuizForm.new(current_step: params[:id].to_i, current_user_id: current_user.id)
  end

  private

  # Checks if both quiz form and encoded params are present.
  def check_for_encoded_params_and_quiz_form
    params[:quiz_form].present? && params[:encoded_params].present?
  end

  # Decodes encoded parameters into ActionController::Parameters format.
  def decoded_params
    ActionController::Parameters.new(UrlParamsEncoder.decode(params[:encoded_params]))
  end
end

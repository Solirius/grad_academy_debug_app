module StepsControllerHelper
  def encoded_params(form)
    UrlParamsEncoder.encode(form)
  end

  def generate_encoded_params_and_url(current_step, answers)
    encoded_params = UrlParamsEncoder.encode(current_step: current_step + 1, answer: answers)
    encoded_params_safe = URI.encode_www_form_component(encoded_params)
    { encoded_params:, encoded_params_safe: }
  end
end

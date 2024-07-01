require 'rails_helper'

RSpec.describe UrlParamsEncoder, type: :service do
  describe '.encode' do
    let(:params) { { 'quiz_form' => { 'current_step' => '1', 'answer_1' => 'apples', 'answer_2' => 'bananas', 'answer_3' => 'oranges', 'answer_4' => 'grapes', 'answer_5' => 'melons' } } }
    let(:encoded_params) { 'eJwrLM2sik_LL8pVNXVKzCsuTy2KN1Q1dbFNLCjISS1WK8SUNgJJJyXmASFWeWOQfH5RYl46dv0mIPn0osQC7NKmIOnc1Jz8PFTp5NKiotS8kvjiktQCkBJDAJXlQwI=' }

    it 'encodes the params' do
      expect(described_class.encode(params)).to eq(encoded_params)
    end
  end

  describe '.decode' do
    let(:encoded_params) { 'eJwrLM2sik_LL8pVNXVKzCsuTy2KN1Q1dbFNLCjISS1WK8SUNgJJJyXmASFWeWOQfH5RYl46dv0mIPn0osQC7NKmIOnc1Jz8PFTp5NKiotS8kvjiktQCkBJDAJXlQwI=' }
    let(:decoded_params) { { 'quiz_form' => { 'current_step' => '1', 'answer_1' => 'apples', 'answer_2' => 'bananas', 'answer_3' => 'oranges', 'answer_4' => 'grapes', 'answer_5' => 'melons' } } }

    it 'decodes the params' do
      expect(described_class.decode(encoded_params)).to eq(decoded_params)
    end
  end
end

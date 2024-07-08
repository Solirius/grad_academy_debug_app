class AddPercentageToAnswers < ActiveRecord::Migration[7.1]
  def change
    add_column :answers, :percentage, :integer
  end
end

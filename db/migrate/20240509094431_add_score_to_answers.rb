class AddScoreToAnswers < ActiveRecord::Migration[7.1]
  def change
    add_column :answers, :score, :integer, default: 0

    add_index :answers, :completed
    add_index :answers, :score
  end
end

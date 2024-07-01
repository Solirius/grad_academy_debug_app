class CreateAnswers < ActiveRecord::Migration[7.1]
  def change
    create_table :answers do |t|
      t.references :user, foreign_key: true
      t.text :answer
      t.datetime :date_attempted
      t.boolean :completed

      t.timestamps
    end
  end
end

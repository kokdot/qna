class AddBest1ToAnswers < ActiveRecord::Migration[5.2]
  def change
    add_column :answers, :best, :string
  end
end

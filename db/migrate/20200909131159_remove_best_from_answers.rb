class RemoveBestFromAnswers < ActiveRecord::Migration[5.2]
  def change
    remove_column :answers, :best, :boolean
  end
end

class ChangeTimeframeColumnInLongTermGoalsTableToString < ActiveRecord::Migration[5.0]
  def change
    change_column :long_term_goals, :timeframe, :string
  end
end

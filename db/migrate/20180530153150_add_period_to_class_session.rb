class AddPeriodToClassSession < ActiveRecord::Migration[5.1]
  def change
    add_column :class_sessions, :period, :integer
  end
end

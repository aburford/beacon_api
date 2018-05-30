class RemoveHashValueFromClassSession < ActiveRecord::Migration[5.1]
  def change
    remove_column :class_sessions, :hash_value, :string
  end
end

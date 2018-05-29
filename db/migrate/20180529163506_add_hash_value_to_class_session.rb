class AddHashValueToClassSession < ActiveRecord::Migration[5.1]
  def change
    add_column :class_sessions, :hash_value, :string
  end
end

class RemoveHashFromClassSession < ActiveRecord::Migration[5.1]
  def change
    remove_column :class_sessions, :hash, :string
  end
end

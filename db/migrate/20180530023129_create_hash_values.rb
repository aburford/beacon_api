class CreateHashValues < ActiveRecord::Migration[5.1]
  def change
    create_table :hash_values do |t|
      t.string :value
      t.references :class_session, foreign_key: true
      t.references :attendance_code, foreign_key: true

      t.timestamps
    end
  end
end

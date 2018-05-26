class CreatePresences < ActiveRecord::Migration[5.1]
  def change
    create_table :presences do |t|
      t.boolean :present
      t.references :class_session, foreign_key: true
      t.references :student, foreign_key: true

      t.timestamps
    end
  end
end

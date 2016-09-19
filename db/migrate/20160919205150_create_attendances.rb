class CreateAttendances < ActiveRecord::Migration[5.0]
  def change
    create_table :attendances do |t|
      t.integer :user_id, foreign_key: true
      t.integer :event_id, foreign_key: true

      t.timestamps
    end
  end
end

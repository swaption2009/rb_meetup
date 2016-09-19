class AddStateToAttendance < ActiveRecord::Migration[5.0]
  def change
    add_column :attendances, :state, :string
  end
end

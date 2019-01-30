class AddUserToDoctors < ActiveRecord::Migration[5.2]
  def change
    add_reference :doctors, :user, foreign_key: true
  end
end

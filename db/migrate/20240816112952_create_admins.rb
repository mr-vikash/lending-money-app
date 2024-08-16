class CreateAdmins < ActiveRecord::Migration[7.1]
  def change
    create_table :admins do |t|
      t.string :name
      t.string :email
      t.decimal :wallet_balance

      t.timestamps
    end
  end
end

class UpdateColumnInAdmins < ActiveRecord::Migration[7.1]
  def change
    change_column :admins, :wallet_balance, :decimal, :precision=>6,:scale=>4,:default=>100000
  end
end

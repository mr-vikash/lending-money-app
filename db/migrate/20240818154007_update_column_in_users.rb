class UpdateColumnInUsers < ActiveRecord::Migration[7.1]
  def change
    change_column :users, :wallet_balance, :decimal, :precision=>6,:scale=>4,:default=>10000
  end
end

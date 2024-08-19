class UpdateDefaultAdminWalletAmountTo10Lac < ActiveRecord::Migration[7.1]
  def change
    change_column :admins, :wallet_balance, :decimal, :precision=>7,:scale=>4,:default=>1000000
  end
end

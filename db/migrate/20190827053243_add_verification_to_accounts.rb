class AddVerificationToAccounts < ActiveRecord::Migration[6.0]
  def up
    add_column :accounts, :verified, :boolean, default: false
  end

  def down
    remove_column :accounts, :verified
  end
end

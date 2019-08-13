class CreateAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :accounts do |t|
      t.string :email, index: { unique: true }
      t.string :password_digest

      t.timestamps
    end
  end
end

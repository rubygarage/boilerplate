class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users, id: :uuid do |t|
      t.uuid :account_id, index: true
      t.string :name

      t.timestamps
    end
  end
end

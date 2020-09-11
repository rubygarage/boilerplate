class CreateSettings < ActiveRecord::Migration[6.0]
  def up
    create_table :settings do |t|
      t.string :key, null: false
      t.string :value, null: false

      t.timestamps
    end

    add_index :settings, 'lower(key)', unique: true
  end

  def down
    drop_table :settings
  end
end

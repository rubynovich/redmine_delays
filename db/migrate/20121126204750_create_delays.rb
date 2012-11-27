class CreateDelays < ActiveRecord::Migration
  def self.up
    create_table :delays do |t|
      t.column :user_id, :integer, :null => false
      t.column :delay_on, :date
      t.column :arrival_time, :time
      t.column :reason, :string
      t.column :author_id, :integer, :null => false
      t.column :created_on, :datetime, :null => false
      t.column :updated_on, :datetime, :null => false
    end
  end

  def self.down
    drop_table :delays
  end
end

class CreatePostsTable < ActiveRecord::Migration
  def change
  	create_table :posts  do |t|
  		t.string :title
  		t.text   :body
  		t.datetime :created_at
  		t.integer :user_id
  	end
  end
end

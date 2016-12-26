class AddSlugToPostsAndSubs < ActiveRecord::Migration
  def change
    add_column :posts, :slug, :string
    add_column :subs, :slug, :string

    add_index :posts, :slug, unique: true
    add_index :subs, :slug, unique: true
  end
end

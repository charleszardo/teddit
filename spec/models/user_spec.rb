require 'rails_helper'

RSpec.describe User, type: :model do

  describe "password encryption" do
    it "does not save passwords to the database" do
      User.create!(username: "test_user", password: "abcdef", email: 'xyz@example.com')
      user = User.find_by_username("test_user")
      expect(user.password).not_to be("abcdef")
    end

    it "encrypts the password using BCrypt" do
      expect(BCrypt::Password).to receive(:create)
      User.new(username: "test_user", password: "abcdef")
    end
  end

  describe "validations" do
    it { should validate_presence_of(:username) }
    it { should validate_presence_of(:session_token) }
    it { should validate_presence_of(:password_digest) }
    it { should validate_uniqueness_of(:username) }
  end

  describe "associations" do
    it { should have_many(:subs) }
    it { should have_many(:posts) }
    it { should have_many(:comments) }
    it { should have_many(:votes) }
    it { should have_many(:subscriptions) }
    it { should have_many(:subscribed_subs) }
    it { should have_many(:subscribed_subs_posts) }
    it { should have_many(:comment_votes) }
    it { should have_many(:post_votes) }
  end
end

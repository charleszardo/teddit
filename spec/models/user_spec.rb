require 'rails_helper'

RSpec.describe User, type: :model do

  describe "password encryption" do
    it "does not save passwords to the database" do
      user = create(:user)
      retrieved_user = User.find_by_username(user.username)
      expect(retrieved_user.password).not_to be("abcdef")
    end

    it "encrypts the password using BCrypt" do
      expect(BCrypt::Password).to receive(:create)
      build(:user)
    end

    describe "::find_by_username_and_password" do
      it "returns user if credentials are correct" do
        user = create(:user)
        expect(User.find_by_username_and_password("test_user", "abcdef")).to eq(user)
        expect(User.find_by_username_and_password("test_user", "123456")).to be(nil)
      end
    end
  end

  describe "validations" do
    subject { create(:user) }
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

require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) do
    build(:user)
  end

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

    it "creates a password digest when password is given" do
      expect(user.password_digest).to_not be_nil
    end

    it "creates a session token after initialization" do
      expect(user.session_token).to_not be_nil
    end

    describe "::find_by_username_and_password" do
      it "finds users based on credentials" do
        user = create(:user)
        expect(User.find_by_username_and_password("test_user", "abcdef")).to eq(user)
        expect(User.find_by_username_and_password("test_user", "123456")).to be_nil
      end
    end

    describe "#is_password?" do
      it "determines whether password belongs to user" do
        expect(user.is_password?("abcdef")).to be true
        expect(user.is_password?("123456")).to be false
      end
    end

    describe "#reset_session_token!" do
      it "resets session token" do
        session_token = user.session_token
        user.reset_session_token!
        expect(user.session_token).to_not eq(session_token)
      end
    end
  end

  describe "validations" do
    it { should validate_presence_of(:username) }
    it { should validate_length_of(:password).is_at_least(6) }
    it { should validate_presence_of(:email) }
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

require 'rails_helper'

RSpec.describe UsersController, :type => :controller do

  describe "GET #new" do
    it "renders the new template" do
      get :new, {}
      expect(response).to render_template("new")
      expect(response).to have_http_status(200)
    end
  end

  describe "POST #create" do
    context "with invalid params" do
      it "validates the presence of the user's username and password" do
        post :create, user: {username: "invalid_user", password: "short"}
        expect(User).to receive(:find_by_username)
        expect(response).to render_template("new")
        expect(flash[:errors]).to be_present
      end
      it "validates that the password is at least 6 characters long"
    end

    context "with valid params" do
      it "redirects user to links index on success" do
        post :create, user: { username: "valid_user", password: "valid_password", email: "email@example.com"}
        expect(response).to redirect_to(root_url)
      end
    end
  end
end

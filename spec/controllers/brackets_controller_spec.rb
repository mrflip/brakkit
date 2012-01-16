require File.dirname(__FILE__) + '/../spec_helper'

describe BracketsController do
  render_views
  login_user
  let(:bracket ){  Fabricate(:bracket) }
  let(:brackets){  [bracket] }

  it "index action should render index template" do
    brackets
    get :index
    response.should render_template(:index)
  end

  it "show action should render show template" do
    get :show, :id => bracket
    response.should render_template(:show)
  end

  it "edit action should render edit template" do
    get :edit, :id => bracket
    response.should render_template(:edit)
  end

  it "update action should render edit template when model is invalid" do
    bracket
    Bracket.any_instance.stub(:valid?).and_return(false)
    put :update, :id => bracket
    response.should render_template(:edit)
  end

  it "update action should redirect when model is valid" do
    Bracket.any_instance.stub(:valid?).and_return(true)
    put :update, :id => bracket
    response.should redirect_to(bracket_url(assigns[:bracket]))
  end

  it "destroy action should destroy model and redirect to index action" do
    delete :destroy, :id => bracket
    response.should redirect_to(brackets_url)
    Bracket.exists?(bracket.id).should be_false
  end
end

require File.dirname(__FILE__) + '/../spec_helper'

describe ContestantsController do
  render_views
  login_user
  let(:contestant ){  Fabricate(:contestant) }
  let(:contestants){  [contestant] }

  it "index action should render index template" do
    contestants
    get :index
    response.should render_template(:index)
  end

  it "show action should render show template" do
    get :show, :id => contestant
    response.should render_template(:show)
  end

  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end

  it "create action should render new template when model is invalid" do
    Contestant.any_instance.stub(:valid?).and_return(false) # careful - handles won't be generated
    post :create
    response.should render_template(:new)
  end

  it "create action should redirect when model is valid" do
    post :create
    response.should redirect_to(contestant_url(assigns[:contestant]))
  end

  it "edit action should render edit template" do
    get :edit, :id => contestant
    response.should render_template(:edit)
  end

  it "update action should render edit template when model is invalid" do
    contestant
    Contestant.any_instance.stub(:valid?).and_return(false)
    put :update, :id => contestant
    response.should render_template(:edit)
  end

  it "update action should redirect when model is valid" do
    Contestant.any_instance.stub(:valid?).and_return(true)
    put :update, :id => contestant
    response.should redirect_to(contestant_url(assigns[:contestant]))
  end

  it "destroy action should destroy model and redirect to index action" do
    delete :destroy, :id => contestant
    response.should redirect_to(contestants_url)
    Contestant.exists?(contestant.id).should be_false
  end
end

require File.dirname(__FILE__) + '/../spec_helper'

describe TournamentsController do
  fixtures :all
  render_views
  login_user

  it "index action should render index template" do
    get :index
    response.should render_template(:index)
  end

  it "show action should render show template" do
    get :show, :id => Tournament.first
    response.should render_template(:show)
  end

  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end

  it "create action should render new template when model is invalid" do
    Tournament.any_instance.stub(:valid?).and_return(false)
    post :create, :tournament => Fabricate.attributes_for(:tournament)
    response.should render_template(:new)
  end

  it "create action should redirect when model is valid" do
    Tournament.any_instance.stub(:valid?).and_return(true)
    post :create, :tournament => Fabricate.attributes_for(:tournament)
    response.should redirect_to(tournament_url(assigns[:tournament]))
  end

  it "edit action should render edit template" do
    get :edit, :id => Tournament.first
    response.should render_template(:edit)
  end

  it "update action should render edit template when model is invalid" do
    Tournament.any_instance.stub(:valid?).and_return(false)
    put :update, :id => Tournament.first
    response.should render_template(:edit)
  end

  it "update action should redirect when model is valid" do
    Tournament.any_instance.stub(:valid?).and_return(true)
    put :update, :id => Tournament.first
    response.should redirect_to(tournament_url(assigns[:tournament]))
  end

  it "destroy action should destroy model and redirect to index action" do
    tournament = Tournament.first
    delete :destroy, :id => tournament
    response.should redirect_to(tournaments_url)
    Tournament.exists?(tournament.id).should be_false
  end
end

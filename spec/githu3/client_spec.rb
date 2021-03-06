require 'helper'

describe Githu3::Client do

  before do
    @client = Githu3::Client.new("myvalidtoken")
  end
  
  describe "Getting my stuff..." do
    it "should be true if method exists" do
      defined?(Githu3::VERSION).should be_true
    end
    
    
    it 'should be oauthed as me...' do
      stub_get "/user", "me"
      @client.me.login.should == 'sbellity'
    end
    
    it 'should retreive rails org' do
      stub_get "/orgs/rails", "orgs/rails"
      @client.org('rails').login.should == 'rails'
    end
    
    it 'should retreive my orgs' do
      stub_get "/user/orgs", "orgs"
      @client.orgs.length.should == 2
      @client.orgs.first.login.should == "nuvoli"
    end
    
    it 'should retrieve all my repos' do
      stub_get "/user/repos", "all_repos"
      @client.repos.length.should == 2
      @client.repos.first.name.should == "brm-ruby-logger"
      @client.repos.first.private.should == true
    end
    
    it 'should retrieve all my public repos' do
      stub_get "/user/repos?type=public", "public_repos"
      @client.repos(:type => "public").length.should == 5
      @client.repos(:type => "public").first.name.should == "futon4mongo"
    end
    
    it 'should tell me if i am following someone else...' do
      stub_request(:get, "#{Githu3::Client::BaseUrl}/user/following/billevans").to_return(:status => 204)
      @client.following?('billevans').should be_true
    end
    
    it 'should tell me if i am NOT following someone else...' do
      stub_request(:get, "#{Githu3::Client::BaseUrl}/user/following/mildesdavis").to_return(:status => 404)
      @client.following?('mildesdavis').should be_false
    end
    
    it "should list my followers" do
      stub_get "/user/followers", "users/followers"
      @client.followers.length.should == 13
    end
    
    it "should list my following" do
      stub_get "/user/following", "users/following"
      @client.following.length.should == 30
    end

  end

end

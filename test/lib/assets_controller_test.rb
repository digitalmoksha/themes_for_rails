# encoding: utf-8
require File.expand_path("test/test_helper.rb")

#--- only way I found to fix a "In order to use #url_for" error
module ActionController::UrlFor
  def _routes
    Rails.application.routes
  end
end

module ThemesForRails
  include Rails.application.routes.url_helpers
  class AssetsControllerTest < ::ActionController::TestCase  
    
    
    tests ThemesForRails::AssetsController
    
    should "respond to stylesheets" do
      assert @controller.respond_to?(:stylesheets)
    end

    should "respond with the right stylesheet file when requested" do
      get 'stylesheets', { :theme => 'default', :asset => 'style.css'}
      assert_response :success
      assert_equal @response.content_type, 'text/css'
    end
    
    should "not be success when the stylesheet file is not found" do
      get 'stylesheets', { :theme => 'default', :asset => 'oldstyle.css'}
      assert_response :missing
    end
    
    # javascripts
    should "respond to javascripts" do
      assert @controller.respond_to?(:javascripts)
    end

    should "respond with the right javascript file when requested" do
      get 'javascripts', { :theme => 'default', :asset => 'app.js'}
      assert_response :success
      assert_equal @response.content_type, 'text/javascript'
    end

    should "respond with the right javascript file when requested (including multiple dot on the filename)" do
      get 'javascripts', { :theme => 'default', :asset => 'app.min.js'}
      assert_response :success
      assert_equal @response.content_type, 'text/javascript'
    end

    should "not be success when the javascript file is not found" do
      get 'javascripts', { :theme => 'default', :asset => 'oldapp.js'}
      assert_response :missing
    end
    
    # images
    should "respond to images" do
      assert @controller.respond_to?(:images)
    end

    should "respond with the right image file when requested" do
      get 'images', { :theme => 'default', :asset => 'logo.png'}
      assert_response :success
      assert_equal  'image/png', @response.content_type
    end
    
    should "not be success when the image file is not found" do
      get 'images', { :theme => 'default', :asset => 'i_am_not_here.jpg'}
      assert_response :missing
    end
    
    should "respond with a nested asset" do
      get 'images', { :theme => 'default', :asset => 'nested/nested_logo.png'}
      assert_response :success
      assert_equal 'image/png', @response.content_type
    end
    
    should "respond with properly even when requesting an image inside the stylesheets folder" do
      get 'stylesheets', { :theme => 'default', :asset => 'images/logo.png'}
      assert_response :success
      assert_equal @response.content_type, 'image/png'
    end
  end
end
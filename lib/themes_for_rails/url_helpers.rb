# encoding: utf-8
module ThemesForRails
  module UrlHelpers

    extend ActiveSupport::Concern

    included do
      helper_method :current_theme_stylesheet_path,
        :current_theme_javascript_path,
        :current_theme_image_path
    end

    def current_theme_stylesheet_path(asset)
      base_theme_stylesheet_path(:theme => self.theme_name, :asset => digest_for_stylesheet(check_add_extension(asset, '.css'), self.theme_name))
    end

    def current_theme_javascript_path(asset)
      base_theme_javascript_path(:theme => self.theme_name, :asset => digest_for_javascript(check_add_extension(asset, '.js'), self.theme_name))
    end

    def current_theme_image_path(asset)
      base_theme_image_path(:theme => self.theme_name, :asset => digest_for_image(asset, self.theme_name))
    end

  end
end
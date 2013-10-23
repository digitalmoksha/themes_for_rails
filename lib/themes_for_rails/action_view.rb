# encoding: utf-8
module ThemesForRails

  module ActionView

    extend ActiveSupport::Concern

    included do
      include ThemesForRails::CommonMethods
    end

    def current_theme_stylesheet_path(asset)
      theme_stylesheet_path(asset)
    end

    def current_theme_javascript_path(asset)
      theme_javascript_path(asset)
    end

    def current_theme_image_path(asset)
      theme_image_path(asset)
    end

    def theme_stylesheet_path(asset, options = self.theme_name)
      theme = options.is_a?(String) ? options : options[:theme]
      base_theme_stylesheet_path(:theme => theme, :asset => digest_for_stylesheet(check_add_extension(asset, '.css'), new_theme_name))
    end

    def theme_javascript_path(asset, options = self.theme_name)
      theme = options.is_a?(String) ? options : options[:theme]
      base_theme_javascript_path(:theme => theme, :asset => digest_for_javascript(check_add_extension(asset, '.js'), new_theme_name))
    end

    def theme_image_path(asset, options = self.theme_name)
      theme = options.is_a?(String) ? options : options[:theme]
      base_theme_image_path(:theme => theme, :asset => digest_for_image("#{asset}", new_theme_name))
    end

    def theme_image_tag(source, options = {})
      image_tag(theme_image_path(source, options[:theme] || self.theme_name), options.except(:theme))
    end

    def theme_image_submit_tag(source, options = {})
      image_submit_tag(theme_image_path(source, options[:theme] || self.theme_name), options.except(:theme))
    end

    def theme_javascript_include_tag(*files)
      options = files.extract_options!
      options.merge!({ :type => "text/javascript" })
      theme = options[:theme] || self.theme_name
      files_with_options = files.collect {|file| theme_javascript_path(file, theme) }
      files_with_options += [options.except(:theme)]

      javascript_include_tag(*files_with_options)
    end

    def theme_stylesheet_link_tag(*files)
      options = files.extract_options!
      options.merge!({ :type => "text/css" })
      theme = options[:theme] || self.theme_name
      files_with_options = files.collect {|file| theme_stylesheet_path(file, theme) }
      files_with_options += [options.except(:theme)]

      stylesheet_link_tag(*files_with_options)
    end
  end
end

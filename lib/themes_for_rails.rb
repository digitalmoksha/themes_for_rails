# encoding: utf-8
module ThemesForRails

  class << self

    def config
      @config ||= ThemesForRails::Config.new
      yield(@config) if block_given?
      @config
    end
    
    def available_themes(&block)
      Dir.glob(File.join(config.themes_path, "*"), &block) 
    end
    alias each_theme_dir available_themes
    
    def available_theme_names
      available_themes.map {|theme| File.basename(theme) } 
    end
    
    def add_themes_path_to_sass
      if ThemesForRails.config.sass_is_available?
        each_theme_dir do |dir|
          if File.directory?(dir) # Need to get rid of the '.' and '..'

            sass_dir = "#{dir}/stylesheets/sass"
            css_dir = "#{dir}/stylesheets"

            unless already_configured_in_sass?(sass_dir)
              Sass::Plugin.add_template_location sass_dir, css_dir 
            end
          end
        end 
      else
        raise "Sass is not available. What are you trying to do?"
      end
    end

    def check_asset_pipeline
      #--- only set if it hasn't already been set - honor what was set by the user
      if config.asset_digests_enabled.nil?
        config.asset_digests_enabled = Rails.application.config.respond_to?(:assets) && Rails.application.config.assets.digest == true
      else
        config.asset_digests_enabled
      end
    end

    def add_themes_assets_to_asset_pipeline
      Rails.logger.info "Adding themes to assets [#{ThemesForRails.config.asset_digests_enabled?}]"
      if ThemesForRails.config.asset_digests_enabled?
        available_theme_names.each do |theme_name|
          theme_asset_path = ThemesForRails.config.assets_dir.gsub(":root", ThemesForRails.config.base_dir).gsub(":name", theme_name.to_s)
          Rails.application.config.assets.paths.prepend(theme_asset_path) unless Rails.application.config.assets.paths.include?(theme_asset_path)
        end unless ThemesForRails.config.base_dir =~ %r!/app/assets/!
      end
    end
    
    def already_configured_in_sass?(sass_dir)
      Sass::Plugin.template_location_array.map(&:first).include?(sass_dir)
    end
    
    #------------------------------------------------------------------------------
    def load_all_theme_data
      available_theme_names.each do |theme_name|
        ThemesForRails.config.load_theme_data(theme_name)
      end
    end

    #------------------------------------------------------------------------------
    def load_locales
      unless ENV['RAILS_GROUPS'] == 'assets'
        available_theme_names.each do |theme_name|
          locale_path = ThemesForRails.config.locales_dir.gsub(":root", ThemesForRails.config.base_dir).gsub(":name", theme_name.to_s)
          Rails.application.config.i18n.load_path += Dir[File.join(locale_path, '*.{rb,yml}').to_s]
        end
      end
    end

  end
end

require 'active_support/dependencies'
require 'themes_for_rails/interpolation'
require 'themes_for_rails/config'
require 'themes_for_rails/common_methods'
require 'themes_for_rails/url_helpers'

require 'themes_for_rails/action_view'
require 'themes_for_rails/assets_controller'
require 'themes_for_rails/action_controller'
require 'themes_for_rails/action_mailer'
require 'themes_for_rails/railtie'
require 'themes_for_rails/routes'


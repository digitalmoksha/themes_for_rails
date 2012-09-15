# encoding: utf-8
module ThemesForRails
  class Railtie < ::Rails::Railtie

    config.themes_for_rails = ActiveSupport::OrderedOptions.new

    config.to_prepare do
      ThemesForRails::Railtie.config.themes_for_rails.each do |key, value|
        ThemesForRails.config.send "#{key}=".to_sym, value
      end

      # Adding theme stylesheets path to sass, automatically.
      if ThemesForRails.config.use_sass?
        ThemesForRails.add_themes_path_to_sass
        ThemesForRails.add_themes_helpers_to_sass
      end

      # Check if asset pipeline enabled
      ThemesForRails.check_asset_pipeline

      # Adding theme assets to the asset pipeline, automatically.
      ThemesForRails.add_themes_assets_to_asset_pipeline if ThemesForRails.config.asset_digests_enabled?

      ActiveSupport.on_load(:action_view) do
        include ThemesForRails::ActionView
      end
      if ThemesForRails.config.asset_digests_enabled?
        ActiveSupport.on_load(:action_view) do
          require 'themes_for_rails/digested_action_view'
          include ThemesForRails::DigestedActionView
        end
      end

      ActiveSupport.on_load(:action_controller) do
        include ThemesForRails::ActionController
      end

      ActiveSupport.on_load(:action_mailer) do
        include ThemesForRails::ActionMailer
      end

      # Add theme support to the sass-rails asset helpers
      ActiveSupport.on_load(:action_view) do
        require 'themes_for_rails/sass_rails_theme_resolver'
        require 'themes_for_rails/sass_rails_theme_helpers'
      end
    end

    config.before_initialize do |app|
      if app.assets
        app.assets.context_class.extend(Sass::Rails::Resolver)
      end
    end
    
    rake_tasks do
      load "tasks/themes_for_rails.rake"
    end
  end
end

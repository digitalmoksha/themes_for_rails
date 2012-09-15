require 'sass-rails'

  class Sass::Rails::Resolver

    extend ActiveSupport::Concern

    include ActionView::Helpers::AssetTagHelper
    include ThemesForRails::CommonMethods
    #include ThemesForRails::DigestedActionView

    attr_accessor :context

    def initialize(context)
      @context = context
      #@theme_name = ::ThemesForRails::ActionController.theme_name
    end

    def resolve(path, content_type = :self)
      options = {}
      options[:content_type] = content_type unless content_type.nil?
      context.resolve(path, options)
    rescue Sprockets::FileNotFound, Sprockets::ContentTypeMismatch
      nil
    end

    def source_path(path, ext)
      context.asset_paths.compute_source_path(path, ::Rails.application.config.assets.prefix, ext)
    end

    def public_path(path, scope = nil, options = {})
      context.asset_paths.compute_public_path(path, ::Rails.application.config.assets.prefix, options)
    end

    def process(path)
      context.environment[path].to_s
    end

    def theme_image_path(img)
      #theme_img = theme_prefixed_asset(img, theme_name)
      #theme = img.split('/').first || :default
      Rails.logger.info(img)
      context.image_path(img)
    end

    def video_path(video)
      context.video_path(video)
    end

    def audio_path(audio)
      context.audio_path(audio)
    end

    def javascript_path(javascript)
      context.javascript_path(javascript)
    end

    def stylesheet_path(stylesheet)
      context.stylesheet_path(stylesheet)
    end

    def font_path(font)
      context.font_path(font)
    end
  end

#Sass::Rails::Resolver.send :include, Sass::Rails::Resolver

require 'sass'
require 'sass/script/functions'
require 'sass-rails'

module ThemesForRails
  module Sass
    module Helpers

      include ::Sass::Rails::Helpers
      include ThemesForRails::CommonMethods

      def asset_data_url(path)
        data = context_asset_data_uri(path.value)
        ::Sass::Script::String.new(%Q{url(#{data})})
      end

      def asset_path(asset, kind)
        ::Sass::Script::String.new(public_path(asset.value, kind.value), true)
      end

      def asset_url(asset, kind)
        ::Sass::Script::String.new(%Q{url(#{public_path(asset.value, kind.value)})})
      end

      [:image, :video, :audio, :javascript, :stylesheet, :font].each do |asset_class|
        class_eval %Q{
          def theme_#{asset_class}_path(asset)
            ::Sass::Script::String.new(resolver.theme_#{asset_class}_path(asset.value), true)
          end
          def theme_#{asset_class}_url(asset)
            ::Sass::Script::String.new("url(" + resolver.theme_#{asset_class}_path(asset.value) + ")")
          end
        }, __FILE__, __LINE__ - 6
      end

      protected

      def resolver
        options[:custom][:resolver]
      end

      def public_path(asset, kind)
        resolver.public_path(asset, kind.pluralize)
      end

      def context_asset_data_uri(path)
        resolver.context.asset_data_uri(path)
      end
    end
  end
end

Sass::Script::Functions.send :include, ThemesForRails::Sass::Helpers
#Sass::Script::Functions.send :include, ThemesForRails::CommonMethods

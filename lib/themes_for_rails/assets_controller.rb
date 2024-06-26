# encoding: utf-8
require "action_controller/metal"

module ThemesForRails
  class AssetsController < ActionController::Base

    def stylesheets
      handle_asset("stylesheets")
    end

    def javascripts
      handle_asset("javascripts")
    end

    def images
      handle_asset("images")
    end

  private

    def handle_asset(prefix)
      asset, theme = params[:asset], params[:theme]
      find_themed_asset(asset, theme, prefix) do |path, mime_type|
        response.headers['ETag'] = %("#{Digest::MD5.hexdigest(ActiveSupport::Cache.expand_cache_key(File.mtime(path).to_s + path))}")
        response.headers['Cache-Control'] = ThemesForRails.config.assets_cache_control
        send_file path, :type => mime_type, :disposition => "inline"
      end
    end

    def find_themed_asset(asset_name, asset_theme, asset_type, &block)
      path = asset_path(asset_name, asset_theme, asset_type)
      if File.exist?(path)
        yield path, mime_type_for(request)
      elsif File.extname(path).blank? || (File.extname(path) != File.extname(request.path_info))
        asset_name = "#{asset_name}.#{extension_from(request.path_info)}"
        return find_themed_asset(asset_name, asset_theme, asset_type, &block)
      elsif asset_theme != ThemesForRails.config.parent_theme(asset_theme)
        #--- last try, check the parent theme
        return find_themed_asset(asset_name, ThemesForRails.config.parent_theme(asset_theme), asset_type, &block)
      else
        render_not_found
      end
    end

    def asset_path(asset_name, asset_theme, asset_type)
      File.join(theme_asset_path_for(asset_theme), asset_type, asset_name)
    end

    def render_not_found
      render :text => 'Not found', :status => 404
    end

    def mime_type_for(request)
      existing_mime_type = mime_type_from_uri(request.path_info)
      unless existing_mime_type.nil?
        existing_mime_type.to_s
      else
        "image/#{extension_from(request.path_info)}"
      end
    end

    def mime_type_from_uri(path)
      extension = extension_from(path)
      Mime::Type.lookup_by_extension(extension)
    end

    def extension_from(path)
      File.extname(path).to_s[1..-1]
    end
  end
end

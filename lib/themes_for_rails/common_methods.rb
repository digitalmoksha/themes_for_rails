# encoding: utf-8
module ThemesForRails
  module CommonMethods

    include ThemesForRails::Interpolation

    def theme_name
      @cached_theme_name ||= begin
        case @theme_name
        when Symbol then
          self.respond_to?(@theme_name, true) ? self.send(@theme_name) : @theme_name.to_s
        when String then @theme_name
        else
          nil
        end
      end
    end

    def theme_name=(name)
      @theme_name = name
    end

    def set_theme(name)
      self.theme_name = name
      if valid_theme?
        add_theme_view_path
      end
    end

    public

    def valid_theme?
      !self.theme_name.nil?
    end

    # will add the view path for the current theme
    def add_theme_view_path
      add_theme_view_path_for(self.theme_name)
    end

    # will add the view path for a given theme name
    def add_theme_view_path_for(name)
      #--- first add the parent theme, to handle any view not found in main theme
      if !ThemesForRails.config.parent_theme(name).blank?
        self.view_paths.insert 0, ::ActionView::FileSystemResolver.new(theme_view_path_for(ThemesForRails.config.parent_theme(name)))
      end
      self.view_paths.insert 0, ::ActionView::FileSystemResolver.new(theme_view_path_for(name))
    end

    #------------------------------------------------------------------------------
    # At some point, "digest" support was added.  However, at least with Rails 3.2.13
    # the call to asset_paths.digest_for() looks up the digest - when passed to
    # the stylesheet or javascript helpers, sprockets gives an error saying the 
    # asset (which has a digest already appened on it) is not compiled.  So pass
    # in the straight asset name, and those helpers lookup the digest and give the 
    # correct path.
    # The code removed looked like this:
      # if ThemesForRails.config.asset_digests_enabled?
      #   asset_paths.digest_for("#{theme_context}/images/#{asset}") || asset
      # else
      #   asset
      # end
    
    def digest_for_image(asset, theme_context)
      if ThemesForRails.config.asset_digests_enabled?
        expanded_asset = "#{theme_context}/images/#{asset}"
        asset.start_with?('/') ? asset : expanded_asset
      else
        asset
      end
    end

    def digest_for_javascript(asset, theme_context)
      if ThemesForRails.config.asset_digests_enabled?
        expanded_asset = "#{theme_context}/javascripts/#{asset}"
        asset.start_with?('/') ? asset : expanded_asset
      else
        asset
      end
    end

    def digest_for_stylesheet(asset, theme_context)
      if ThemesForRails.config.asset_digests_enabled?
        expanded_asset = "#{theme_context}/stylesheets/#{asset}"
        asset.start_with?('/') ? asset : expanded_asset
      else
        asset
      end
    end

    def check_add_extension(asset, ext = '.css')
      asset.end_with?(ext) ? asset : (asset + ext)
    end

    def public_theme_path
      theme_view_path("/")
    end

    def theme_asset_path
      theme_asset_path_for(theme_name)
    end

    def theme_view_path
      theme_view_path_for(theme_name)
    end

    def theme_view_path_for(theme_name)
      interpolate(ThemesForRails.config.views_dir, theme_name)
    end

    def theme_asset_path_for(theme_name)
      interpolate(ThemesForRails.config.assets_dir, theme_name)
    end
  end
end

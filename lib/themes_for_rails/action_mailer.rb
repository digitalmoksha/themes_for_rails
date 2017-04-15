# encoding: utf-8
module ThemesForRails

  module ActionMailer

    extend ActiveSupport::Concern

    included do
      include ThemesForRails::ActionController
      alias_method :original_mail, :mail
    end

    def mail(headers = {}, &block)
      theme_opts = headers[:theme] || headers['X-theme'] || self.class.default[:theme]
      theme(theme_opts) if theme_opts

      original_mail(headers, &block)
    end
    
  end

end

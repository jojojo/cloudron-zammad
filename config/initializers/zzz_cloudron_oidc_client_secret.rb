# frozen_string_literal: true
#
# Cloudron packaging patch (not part of upstream Zammad).
#
# Cloudron's "oidc" addon provisions a confidential OIDC client: its token
# endpoint rejects the authorization code exchange unless a client_secret is
# sent (error observed: "invalid_request :: client_secret must be provided in
# the Authorization header"). Zammad's built-in generic OpenID Connect
# strategy (OmniAuth::Strategies::OidcDatabase) only supports public clients
# -- there is no client_secret field in the "OpenID Connect Options" Setting,
# and the `client_options` hash it builds only ever contains `identifier` and
# `redirect_uri`.
#
# This initializer prepends a small wrapper around .setup that injects the
# secret Cloudron exports as CLOUDRON_OIDC_CLIENT_SECRET into client_options,
# without altering any other Zammad behavior. It is a no-op (and harmless) in
# any environment where that variable isn't set, e.g. outside Cloudron.
Rails.application.config.to_prepare do
  next if ENV['CLOUDRON_OIDC_CLIENT_SECRET'].blank?

  module CloudronOidcClientSecretPatch
    def setup
      options = super
      options[:client_options][:secret] = ENV['CLOUDRON_OIDC_CLIENT_SECRET']
      options
    end
  end

  OmniAuth::Strategies::OidcDatabase.singleton_class.prepend(CloudronOidcClientSecretPatch)
end

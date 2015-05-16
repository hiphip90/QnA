# taken from https://gist.github.com/kinopyo/1338738

module OAuthHelpers
  def mock_auth_hash(provider)
    # The mock_auth configuration allows you to set per-provider (or default)
    # authentication hashes to return during integration testing.
    email = 'example@example.com' if provider != :twitter
    OmniAuth.config.mock_auth[provider] = OmniAuth::AuthHash.new({
      'provider' => provider,
      'uid' => '123545',
      'info' => {
        'email' => email,
        'name' => 'mockuser',
        'image' => 'mock_user_thumbnail_url'
      },
      'credentials' => {
        'token' => 'mock_token',
        'secret' => 'mock_secret'
      }
    })
  end
end
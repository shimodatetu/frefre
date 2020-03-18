# Copyright 2016 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

##
# This file is here to be autorequired by bundler, so that the
# Google::Cloud.translate and Google::Cloud#translate methods can be available,
# but the library and all dependencies won't be loaded until required and used.


gem "google-cloud-core"
require "google/cloud" unless defined? Google::Cloud.new
require "google/cloud/config"
require "googleauth"

module Google
  module Cloud
    ##
    # Creates a new object for connecting to the Cloud Translation API. Each
    # call creates a new connection.
    #
    # Like other Cloud Platform services, Google Cloud Translation API supports
    # authentication using a project ID and OAuth 2.0 credentials. In addition,
    # it supports authentication using a public API access key. (If both the API
    # key and the project and OAuth 2.0 credentials are provided, the API key
    # will be used.) Instructions and configuration options are covered in the
    # {file:AUTHENTICATION.md Authentication Guide}.
    #
    # @param [String] key a public API access key (not an OAuth 2.0 token)
    # @param [String, Array<String>] scope The OAuth 2.0 scopes controlling the
    #   set of resources and operations that the connection can access. See
    #   [Using OAuth 2.0 to Access Google
    #   APIs](https://developers.google.com/identity/protocols/OAuth2).
    #
    #   The default scope is:
    #
    #   * `https://www.googleapis.com/auth/cloud-platform`
    # @param [Integer] retries Number of times to retry requests on server
    #   error. The default value is `3`. Optional.
    # @param [Integer] timeout Default timeout to use in requests. Optional.
    #
    # @return [Google::Cloud::Translate::Api]
    #
    # @example
    #   require "google/cloud"
    #
    #   gcloud = Google::Cloud.new
    #   translate = gcloud.translate "api-key-abc123XYZ789"
    #
    #   translation = translate.translate "Hello world!", to: "la"
    #   translation.text #=> "Salve mundi!"
    #
    # @example Using API Key from the environment variable.
    #   require "google/cloud"
    #
    #   ENV["TRANSLATE_KEY"] = "api-key-abc123XYZ789"
    #
    #   gcloud = Google::Cloud.new
    #   translate = gcloud.translate
    #
    #   translation = translate.translate "Hello world!", to: "la"
    #   translation.text #=> "Salve mundi!"
    #
    def translate key = nil, scope: nil, retries: nil, timeout: nil
      Google::Cloud.translate key, project_id: @project, credentials: @keyfile,
                                   scope: scope,
                                   retries: (retries || @retries),
                                   timeout: (timeout || @timeout)
    end

    ##
    # Creates a new object for connecting to the Cloud Translation API. Each
    # call creates a new connection.
    #
    # Like other Cloud Platform services, Google Cloud Translation API supports
    # authentication using a project ID and OAuth 2.0 credentials. In addition,
    # it supports authentication using a public API access key. (If both the API
    # key and the project and OAuth 2.0 credentials are provided, the API key
    # will be used.) Instructions and configuration options are covered in the
    # {file:AUTHENTICATION.md Authentication Guide}.
    #
    # @param [String] key a public API access key (not an OAuth 2.0 token)
    # @param [String] project_id Project identifier for the Cloud Translation
    #   service you are connecting to. If not present, the default project for
    #   the credentials is used.
    # @param [String, Hash, Google::Auth::Credentials] credentials The path to
    #   the keyfile as a String, the contents of the keyfile as a Hash, or a
    #   Google::Auth::Credentials object. (See {Translate::Credentials})
    # @param [String, Array<String>] scope The OAuth 2.0 scopes controlling the
    #   set of resources and operations that the connection can access. See
    #   [Using OAuth 2.0 to Access Google
    #   APIs](https://developers.google.com/identity/protocols/OAuth2).
    #
    #   The default scope is:
    #
    #   * `https://www.googleapis.com/auth/cloud-platform`
    # @param [Integer] retries Number of times to retry requests on server
    #   error. The default value is `3`. Optional.
    # @param [Integer] timeout Default timeout to use in requests. Optional.
    # @param [String] project Alias for the `project_id` argument. Deprecated.
    # @param [String] keyfile Alias for the `credentials` argument.
    #   Deprecated.
    #
    # @return [Google::Cloud::Translate::Api]
    #
    # @example
    #   require "google/cloud"
    #
    #   translate = Google::Cloud.translate "api-key-abc123XYZ789"
    #
    #   translation = translate.translate "Hello world!", to: "la"
    #   translation.text #=> "Salve mundi!"
    #
    # @example Using API Key from the environment variable.
    #   require "google/cloud"
    #
    #   ENV["TRANSLATE_KEY"] = "api-key-abc123XYZ789"
    #
    #   translate = Google::Cloud.translate
    #
    #   translation = translate.translate "Hello world!", to: "la"
    #   translation.text #=> "Salve mundi!"
    #
    def self.translate key = nil, project_id: nil, credentials: nil, scope: nil,
                       retries: nil, timeout: nil, project: nil, keyfile: nil
      require "google/cloud/translate"
      Google::Cloud::Translate.new key: key, project_id: project_id,
                                   credentials: credentials,
                                   scope: scope, retries: retries,
                                   timeout: timeout,
                                   project: project, keyfile: keyfile
    end
  end
end

# Set the default translate configuration
Google::Cloud.configure.add_config! :translate do |config|
  default_project = Google::Cloud::Config.deferred do
    ENV["TRANSLATE_PROJECT"]
  end
  default_creds = Google::Cloud::Config.deferred do
    Google::Cloud::Config.credentials_from_env(
      "TRANSLATE_CREDENTIALS", "TRANSLATE_CREDENTIALS_JSON",
      "TRANSLATE_KEYFILE", "TRANSLATE_KEYFILE_JSON"
    )
  end
  default_key = Google::Cloud::Config.deferred do
    ENV["TRANSLATE_KEY"] || ENV["GOOGLE_CLOUD_KEY"]
  end

  config.add_field! :project_id, default_project, match: String, allow_nil: true
  config.add_alias! :project, :project_id
  config.add_field! :credentials, default_creds,
                    match: [String, Hash, Google::Auth::Credentials],
                    allow_nil: true
  config.add_alias! :keyfile, :credentials
  config.add_field! :key, default_key, match: String, allow_nil: true
  config.add_field! :scope, nil, match: [String, Array]
  config.add_field! :retries, nil, match: Integer
  config.add_field! :timeout, nil, match: Integer
end

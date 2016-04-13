require_relative '../../../components/shared/lib/shared/stuba/ais'

module Shared::AuthenticationHelper
  def login_as(user, options = {})
    stub_ais_for(user) if options[:with] == :AIS

    visit shared.new_user_session_path context: 1 if Rails.module.mooc?
    visit shared.new_user_session_path unless Rails.module.mooc?

    fill_in 'user_login', with: user.login
    fill_in 'user_password', with: user.password || options[:password] || 'password'

    click_button 'Prihlásiť'
  end

  def stub_ais_for(user = nil, options = {})
    user ||= build :user, :as_ais

    data = {
      uisid: [user.ais_uid],
      uid: [user.login],
      cn: ["#{user.name}"],
      sn: [user.last],
      givenname: [user.first],
      mail: [user.email],
      employeetype: [user.role],
      accountstatus: ['uis:active']
    }

    Shared::Stuba::AIS.stub(:authenticate).with(user.login, options[:password] || 'password') do
      Shared::Stuba::User.new(data)
    end
  end

  RSpec.configure do |config|
    config.before :each, type: :feature do
      Shared::Stuba::AIS.stub(:authenticate) { nil }
    end
  end
end

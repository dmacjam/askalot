module Shared
class ApplicationController < ActionController::Base
  helper Mooc::Engine.helpers if Rails.module.mooc?

  before_action :determine_context

  def default_url_options(options={})
    return {} if Rails.module.university? || params[:context]
    { context: Shared::ApplicationHelper.current_context }
  end

  protected

  # concerns order is significant
  include Shared::Applications::Security
  include Shared::Applications::Flash
  include Shared::Applications::Form
  include Shared::Applications::Tab

  include Shared::Events::Log

  include Shared::Facebook::Modal
  include Shared::Slido::Flash
  include (Rails.module.classify + '::Application').constantize

  def current_ability
    @current_ability ||= Shared::Ability.new(current_user)
  end

  def determine_context
    context = params[:context] || Shared::ApplicationHelper.default_context
    Shared::ApplicationHelper.current_context = context
  end
end
end

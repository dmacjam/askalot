module Shared
class Watching < ActiveRecord::Base
  include Deletable
  include Notifiable

  belongs_to :watcher, class_name: :'Shared::User'

  belongs_to :watchable, -> { unscope where: :deleted }, polymorphic: true

  scope :by, lambda { |user| where(watcher: user) }
  scope :of, lambda { |model| where(watchable_type: model.to_s.classify) }
  scope :in_context, lambda { |context| where(context: context)  unless Rails.module.university? }

  self.table_name = 'watchings'
end
end

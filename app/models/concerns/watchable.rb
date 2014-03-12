module Watchable
  extend ActiveSupport::Concern

  included do
    has_many :watchings, as: :watchable, dependent: :destroy
    has_many :watchers, through: :watchings, source: :watcher

    scope :watched, lambda { joins(:watchings).uniq }
  end

  def watched_by?(user)
    views.exists? watcher: user
  end
end

class Question < ActiveRecord::Base
  include Votable

  belongs_to :author, class_name: :User
  belongs_to :category

  has_many :answers

  has_many :favorites
  has_many :favorers, through: :favorites, source: :user

  has_many :watchings, as: :watchable

  has_many :votes, as: :votable

  has_many :views

  acts_as_taggable

  validates :title, presence: true, length: { minimum: 2, maximum: 250 }
  validates :text,  presence: true, length: { minimum: 2 }

  scope :answered,   lambda { joins(:answers).uniq }
  scope :favored,    lambda { joins(:favorites).uniq }
  scope :favored_by, lambda { |user| joins(:favorites).where(favorites: { user: user }) }

  def labels
    [category] + tags_with_counts
  end

  def tags_with_counts
    tags.each do |tag|
      tag.count = Question.tagged_with(tag.name).count
    end

    tags
  end

  def favored_by?(favorer)
    favorites.exists? user: favorer
  end

  def toggle_favoring_by!(user)
    return Favorite.create! user: user, question: self unless favored_by?(user)

    Favorite.where(user: user, question: self).first.destroy

    self
  end

  def view_by!(user)
    views.create!(user: user)
  end

  def distinct_views_count
    View.where(question: self).distinct.count(:user_id)
  end
end

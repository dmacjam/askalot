class CategoriesController < ApplicationController
  include Watchables::Watch

  before_action :authenticate_user!

  def index
    @categories = Category.order(:name)
    @tags       = Tag.order(:name)
  end
end

class SearchController < ApplicationController
  def show
    @groups = Group.all.where("deleted = false")
  end
end

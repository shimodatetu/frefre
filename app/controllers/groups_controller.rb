class GroupsController < ApplicationController
  def new
    @category = Bigcategory.all
    @thread_types = Threadtype.all
  end
end

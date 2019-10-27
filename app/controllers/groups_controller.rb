class GroupsController < ApplicationController
  def new
    @category = Bigcategory.all
    @thread_types = Threadtype.all
    gon.prohibit = []
    for prohibit in Prohibit.all do
      gon.prohibit.push(prohibit.prohibit_words)
    end
  end
end

class CategoryController < ApplicationController
  def new
    @categories = Bigcategory.all
    @big_new = Bigcategory.new
    @small_new = Smallcategory.new
  end
  def new2
    @categories = Bigcategory.all
    @big_new = Bigcategory.new
    @small_new = Smallcategory.new
  end
  def new3
    @type_all = Threadtype.all
    @type_new = Threadtype.new
  end
  def all_new
    big_ary_en = []
    small_ary_en = []
    small_piece = []
    first = true
    params[:category_en].split("\r\n").each do |en_cate|
      if en_cate.include?('@')
        big_ary_en.push(en_cate.sub(/@/,''))
        if first == true
          first = false
        else
          small_ary_en.push(small_piece)
        end
        small_piece = []
      else
        small_piece.push(en_cate)
      end
    end
    small_ary_en.push(small_piece)
    big_id = -1
    big_real_id = 0
    small_id = 0
    params[:category_jp].split("\r\n").each do |jp_cate|
      if jp_cate.include?('¥')
        return
      elsif jp_cate.include?('＠')
        big_id+=1
        bigcategory = Bigcategory.new()
        bigcategory.name_en = big_ary_en[big_id]
        bigcategory.name_jp = jp_cate.sub(/＠/,'')
        bigcategory.save
        big_real_id = bigcategory.id
        small_id = 0
      else
        smallcategory = Smallcategory.new()
        smallcategory.name_en = small_ary_en[big_id][small_id]
        smallcategory.name_jp = jp_cate
        smallcategory.bigcategory_id = big_real_id
        small_id += 1
        if smallcategory.save
        else
        end
      end
    end
  end

  def show
    @category = Bigcategory.all
    @threadtypes = Threadtype.all
  end
  def show2
    @category = Bigcategory.all
    @threadtypes = Threadtype.all
  end

  def typecategory
    @threadtypes = Threadtype.all
    @test_id = params[:id]
    typecategory_id = params[:id].to_i
    a_type =  @threadtypes.find(typecategory_id)
    if a_type.present?
      thread_page_num = 10.to_f
      page_show_max = 5.to_f
      page_max_half = (page_show_max / 2).ceil
      group_num = a_type.groups.all.count
      page_num = (group_num / thread_page_num).ceil
      if page_num == 0
        page_num = 1
      end
      page_id = params[:page].to_i
      if page_id.nil? || page_id.to_i > page_num || page_id.to_i < 1
       page_id = 1
      end
      start_num = 1
      end_num = page_num
      if page_num > page_show_max
       if page_id - page_max_half < 0
         end_num = page_show_max
       elsif page_id + page_max_half > page_num
         start_num = end_num - page_show_max + 1
       else
         start_num = page_id - page_max_half + 2
         end_num = start_num + page_show_max - 1
       end
      end

      @thread_page_num = thread_page_num
      @page_id = page_id
      @page_num = page_num
      @start_num = start_num
      @end_num = end_num
    else
      @thread_page_num = 0
      @page_id = 0
      @page_num = 0
      @start_num = 0
      @end_num = 0
    end
  end

  def smallcategory
    @categories = Smallcategory.all
    @test_id = params[:id]
    smallcategory_id = params[:id].to_i
    a_smallcategory =  @categories.find(smallcategory_id)
    if a_smallcategory.present?
      thread_page_num = 10.to_f
      page_show_max = 5.to_f
      page_max_half = (page_show_max / 2).ceil
      group_num = a_smallcategory.groups.all.count
      a
      page_num = (group_num / thread_page_num).ceil
      if page_num == 0
        page_num = 1
      end
      page_id = params[:page].to_i
      if page_id.nil? || page_id.to_i > page_num || page_id.to_i < 1
       page_id = 1
      end
      start_num = 1
      end_num = page_num
      if page_num > page_show_max
       if page_id - page_max_half < 0
         end_num = page_show_max
       elsif page_id + page_max_half > page_num
         start_num = end_num - page_show_max + 1
       else
         start_num = page_id - page_max_half + 2
         end_num = start_num + page_show_max - 1
       end
      end

      @thread_page_num = thread_page_num
      @page_id = page_id
      @page_num = page_num
      @start_num = start_num
      @end_num = end_num
    else
      @thread_page_num = 0
      @page_id = 0
      @page_num = 0
      @start_num = 0
      @end_num = 0
    end
  end

  def big_new
    @big_new = Bigcategory.new(big_param)
    if @big_new.save
      redirect_to "/category/new"
    end
  end

  def small_new
    @small_new = Smallcategory.new(small_param)
    if @small_new.save
      redirect_to "/category/new"
    end
  end

  def type_new
    @type_new = Threadtype.new(type_en: params[:threadtype][:type_en],type_jp: params[:threadtype][:type_jp])
    if @type_new.save
      redirect_to "/category/new3"
    end
  end

  private
  def big_param
    params.require(:bigcategory).permit(:name_en,:name_jp)
  end
  def small_param
    params.require(:smallcategory).permit(:name_en,:name_jp,:bigcategory_id)
  end
end

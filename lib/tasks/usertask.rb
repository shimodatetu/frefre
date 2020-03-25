
require "#{Rails.root}/app/models/user"
require "#{Rails.root}/app/models/group"
require "#{Rails.root}/app/models/post"
class HelloBatch
  def self.execute
    puts "======================="
    for user in User.all do
      group_have = []
      for group in user.groups do
        if group.posts.where(updated_at: Time.zone.today.beginning_of_day..Time.zone.today.end_of_day)[0] != nil
          group_have.push(group)
        end
      end
      if group_have.length > 0
        puts EverydayMailer.everyday_mail(user,group_have)

        puts user.name
        puts group.title_en
        puts "======================="
      end
    end
  end
end

HelloBatch.execute

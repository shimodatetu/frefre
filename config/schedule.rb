require File.expand_path(File.dirname(__FILE__) + "/environment")
set :environment, "development"
set :output, { :error => "log/cron_error.log" }
set :path, "appへのpath"

every 3.hours do # 1.minute 1.day 1.week 1.month 1.yearなどをサポート
  rake "rake:task"
  command "/command_path"
end

every 1.minutes do
  runner 'Tasks::Usertask.create'

end

every 1.day, at: ['4:00 am', '1:00 pm'] do
  runner "Runner.task"
end

every :hour do # ショートカット達 :hour, :day, :month, :year, :reboot
  runner "Runner.task"
end


every '0 0 27-31 * *' do
  command "echo 'hogehoge'"
end
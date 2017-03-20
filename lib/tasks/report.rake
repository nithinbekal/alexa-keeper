desc "Send email to users" 
task :email_sender => :environment do
  Rails.logger.info "[Email Sender] inside rake task"
  User.find_each do |user| 
    data = [] 
    user.collections.each do |collect|
      collect.websites.each do |website| 
        rank1 = website.alexaranks.find_by(created_at: (Date.current-7).beginning_of_day..(Date.current-7).end_of_day)&.rank
        rank2 = website.alexaranks.find_by(created_at: (Date.current).beginning_of_day..(Date.current).end_of_day)&.rank 
        change = rank1-rank2 if rank1 && rank2 
        data << { url: website.url, rank1: rank1, rank2:rank2, change: change ,list: collect.name} 
      end
    end 
    UserMailer.weekly_mail(user,data).deliver_now if Date.current.monday? 
  end 
end
module PhotosHelper
  def minutes_ago time
    seconds = (Time.zone.now - time).to_i
    minute = seconds/1.minute
    hour = seconds/1.hour
    day = seconds/1.day
    month = seconds/1.month
    year = seconds/1.year
    return "#{minute} #{'minute'.pluralize(minute)} ago" if minute < 60
    return "#{hour} #{'hour'.pluralize(hour)} ago" if hour < 24
    return "#{day} #{'day'.pluralize(day)} ago" if day < 31
    return "#{month} #{'month'.pluralize(month)} ago" if month < 12
    return "#{year} #{'year'.pluralize(year)} ago"
  end
end

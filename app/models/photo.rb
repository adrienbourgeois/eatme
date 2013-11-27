class Photo < ActiveRecord::Base
  belongs_to :place

  PER_PAGE = 9

  def self.get_last_photos(page)
    photos = Photo.all.where(checked:true).order(created_at: :desc).page(page).per(PER_PAGE)
    photos_js = JSON.parse(photos.to_json(include: :place))
    photos_js.each { |photo| photo['minutes_ago'] = minutes_ago(photo['updated_at']) }
    #return photos_js
  end


  private
  def self.minutes_ago time
    time = Time.zone.parse time
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

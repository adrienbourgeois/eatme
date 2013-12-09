class Photo < ActiveRecord::Base
  belongs_to :place
  validates :instagram_id,:image_low_resolution,:image_thumbnail,:tags, presence: true
  validates :image_standard_resolution,:instagram_url,:instagram_body_req, presence: true
  validates :instagram_id, numericality: { only_integer: true }
  validates :checked, inclusion: { in: [true,false], message: "has to be true or false" }

  PER_PAGE = 9

  def self.get_last_photos(page)
    photos = Photo.all.where(checked:true).order(created_at: :desc).page(page).per(PER_PAGE)
    photos_js = JSON.parse(photos.to_json(include: :place))
    photos_js.each { |photo| photo['minutes_ago'] = minutes_ago(photo['updated_at']) }
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

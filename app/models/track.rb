class Track < ActiveRecord::Base
  has_many :sessions
  has_many :races

  validates :name, :presence => true, :allow_blank => true, :uniqueness => true
  validates :length, :numericality => true

  attr_accessor :move_sessions_to

  after_save :move_sessions, :unless => Proc.new { |track| track.move_sessions_to.blank? }

  def name
    db_name = read_attribute(:name)
    if db_name.blank?
      "Unknown (length: #{self.length}m)"
    else
      db_name
    end
  end

  private

    def move_sessions
      self.sessions.each { |s| s.update(:track_id => self.move_sessions_to) }
      self.destroy
    end

end

class Driver < ActiveRecord::Base
  attr_accessible :ip, :name, :flair, :colour, :marker, :merge_session_ids
  attr_accessor :merge_session_ids

  has_many :sessions

  has_one :driver_user
  has_one :user, :through => :driver_user

  after_save :adjust_sessions

  def claimed?
    if name.blank?
      'Unknown'
    else
      name
    end
  end

  def self.unclaimed?
    Driver.includes(:driver_user).where('driver_users.user_id is null')
  end

  def adjust_sessions
    unless merge_session_ids.nil?
      merge_session_ids.reject!(&:blank?).map!(&:to_i).collect! { |d| Driver.find(d).session_ids }.flatten!

      current = self.sessions.collect(&:id)
      Session.find((merge_session_ids - current)).each do |session|
        session.update_attribute(:driver_id, self.id)
      end
    end
  end

end

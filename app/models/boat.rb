class Boat < ActiveRecord::Base
  belongs_to  :captain
  has_many    :boat_classifications
  has_many    :classifications, through: :boat_classifications

  def self.first_five
    # all.limit(5)
    self.all.limit(5)
  end

  def self.dinghy
    self.where("length < 20")
  end

  def self.ship
    self.where("length >= 20")
  end

  def self.last_three_alphabetically
    self.all.order(name: :desc).limit(3)
  end

  def self.without_a_captain
    self.where(captain_id: nil)
  end

  def self.sailboats
    self.includes(:classifications).where(classifications: { name: 'Sailboat' })
  end

  def self.with_three_classifications
    # This is really complex! It's not common to write code like this
    # regularly. Just know that we can get this out of the database in
    # milliseconds whereas it would take whole seconds for Ruby to do the same.
    #
    self.joins(:classifications).group("boats.id").having("COUNT(*) = 3").select("boats.*")
  end

  def self.non_sailboats
    self.where("id NOT IN (?)", self.sailboats.pluck(:id))
  end

  def self.longest
    self.order('length DESC').first
  end
end

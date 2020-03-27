class Captain < ActiveRecord::Base
  has_many :boats

  def self.catamaran_operators
    includes(boats: :classifications).where(classifications: {name: "Catamaran"})
  end

  def self.sailors
    includes(boats: :classifications).where(classifications: {name: "Sailboat"}).distinct
    #returns captains with sailboats
    #> Captain.sailors >>  SQL (2.4ms)  SELECT DISTINCT "captains"."id" AS t0_r0, "captains"."name" AS t0_r1, "captains"."admiral" AS t0_r2, "captains"."created_at" AS t0_r3, "captains"."updated_at" AS t0_r4, "boats"."id" AS t1_r0, "boats"."name" AS t1_r1, "boats"."length" AS t1_r2, "boats"."captain_id" AS t1_r3, "boats"."created_at" AS t1_r4, "boats"."updated_at" AS t1_r5, "classifications"."id" AS t2_r0, "classifications"."name" AS t2_r1, "classifications"."created_at" AS t2_r2, "classifications"."updated_at" AS t2_r3 FROM "captains" LEFT OUTER JOIN "boats" ON "boats"."captain_id" = "captains"."id" LEFT OUTER JOIN "boat_classifications" ON "boat_classifications"."boat_id" = "boats"."id" LEFT OUTER JOIN "classifications" ON "classifications"."id" = "boat_classifications"."classification_id" WHERE "classifications"."name" = ?  [["name", "Sailboat"]]
  #<ActiveRecord::Relation [#<Captain id: 1, name: "Captain Cook", admiral: true, created_at: "2020-03-27 21:49:40", updated_at: "2020-03-27 21:49:40">, #<Captain id: 2, name: "Captain Kidd", admiral: true, created_at: "2020-03-27 21:49:40", updated_at: "2020-03-27 21:49:40">, #<Captain id: 6, name: "Samuel Axe", admiral: false, created_at: "2020-03-27 21:49:40", updated_at: "2020-03-27 21:49:40">]> 
  end

  def self.motorboat_operators
    includes(boats: :classifications).where(classifications: {name: "Motorboat"})
  end

  def self.talented_seafarers
    where("id IN (?)", self.sailors.pluck(:id) & self.motorboat_operators.pluck(:id))
  end

  def self.non_sailors
    #returns people who are not captains of sailboats
    where.not("id IN (?)", self.sailors.pluck(:id))
  end

end

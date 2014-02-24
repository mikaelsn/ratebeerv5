class Rating < ActiveRecord::Base
  belongs_to :beer
  belongs_to :user

  validates :score, numericality: { greater_than_or_equal_to: 1,
                                    less_than_or_equal_to: 50,
                                    only_integer: true }

  def to_s
    "#{beer.name} #{score}"
  end

   def self.recent(n)
  	sorted_by_newest = Rating.all.reverse
  	sorted_by_newest.take(5)
  end
end

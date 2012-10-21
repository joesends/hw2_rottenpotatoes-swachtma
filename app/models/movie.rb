class Movie < ActiveRecord::Base

private

  def self.all_ratings
  	ratings = Array.new
  	self.all.each do |m|
  	  ratings += [m.rating] 
  	end

  	ratings.uniq
  end
end

class DiceSet
	attr_accessor :values
	def roll (roll = 0)
		rolls = []
		(0..(roll-1)).each do
			rolls << rand(1..6)
		end
		self.values = rolls
	end
end

dice = DiceSet.new
dice.roll(5)
puts dice.values
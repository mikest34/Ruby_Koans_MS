# EXTRA CREDIT:
#
# Create a program that will play the Greed Game.
# Rules for the game are in GREED_RULES.TXT.
#
# You already have a DiceSet class and score function you can use.
# Write a player class and a Game class to complete the project.  This
# is a free form assignment, so approach it however you desire.

class BustedError < RuntimeError
end

class Greed
	attr_accessor :player_current
	attr_accessor :player_cnt
	attr_accessor :players
	attr_accessor :dice

	def initialize()
		self.players = []
		self.dice = DiceSet.new
		
	end

	def start_game
		print "Enter the number of players\n"
		player_cnt = gets
		if player_cnt.to_i.is_a?(Integer) && player_cnt.to_i >= 2
			self.player_cnt = player_cnt.to_i
			self.add_players
			self.watch_rounds
		else
			print "Invalid input, please try again\n"
			self.start_game
		end
	end

	def display_score
		self.players.each_with_index do |x,i|
			puts "#{x[:name]} (player #{(i+1)}): #{x[:score]} points\n"
		end
	end

	def add_players
		(1..self.player_cnt).each do |x|
			print "Enter name for player #{x}:"
			player_name = gets
			self.new_player(player_name)
		end
	end

	def new_player(name)
		self.players << { name:name, score:0, turn: [], is_turn: false }
	end

	def watch_rounds

		max_score = 0
		round = 1

		while max_score < 3000 do

			self.play_round

			puts "End of round #{round}"
			self.display_score

		end

		puts "Entering the final round\n"

		self.play_round

		puts "Game Over"
		puts "And the winner is...."
		winner = players.sort_by { |h| h[:score] }
		puts "#{winner}"

	end

	def play_round 

		self.players.each_with_index do |player,i|

			begin

				self.player_current = i

				puts "#{player[:name]}, it is your turn."

				self.play_turn(player)
				
				#calculate the score
				score = player[:turn].inject(0){|sum,x| sum + x }
				#add to the game score
				player[:score] += score if score >= 300

				break if player[:score] >= 3000

			rescue BustedError => exception

				puts "You busted! Lost your turn and all accumulated points!\n"

			end

		end

	end

	def play_turn(player)
		#start the turn with a roll
		dice_left = self.roll
		choice = nil
		is_turn = true
		while is_turn do
			puts "Enter 'roll' to roll remaining dice or 'quit' to end the turn"
			choice == gets
			case choice && choice.upcase
			when "roll"
				dice_left = roll(dice_left)
			when "quit"
				break
				end_turn
			else
				puts "I didn't understand that input. Try again\n"
			end
		end
	end

	def roll(dice_cnt=5)
		#implement roll logic
		self.dice.roll(dice_cnt)
		dice_summary = self.roll_summary( self.dice.values )
		roll_score = self.score( dice_summary )

		if roll_score == 0
			raise BustedError
		end

		self.players[self.player_current][:turn] << roll_score
		dice_left_over = self.dice_left(dice_summary)

		puts "Dice roll: #{self.dice.values.to_s}\n"
		puts "Score: #{roll_score} points\n"
		puts "You have #{dice_left_over} dice you can roll\n"
		puts dice_left_over

	end

	def dice_left(roll_result)
		dice_left = 0
		roll_result.each do |k,v|
			dice_left += v if v < 3 && k != 1 && k != 5
		end
		dice_left
	end

	def end_turn(bust=false)
		#add up the round score
		score = self.players[self.player_current][:turn].inject(0){|sum,x| sum + x }
		#add to the game score
		self.players[self.player_current][:score] += score unless bust || score < 300
	end

	def roll_summary(dice)
		dice.inject(Hash.new(0)){|h,k| h[k] += 1;h}
	end

	def score(roll_cnt)
		score = 0
		roll_cnt.each do |k,v|
			score += (k==1?1000:100)*k if v >= 3
			score += (v>=3?(v-3):v)*(k==1?100:50) if k == 1 || k == 5
		end
		score
	end

end


class Player
	attr_reader :name
	attr_accessor :score
	attr_accessor :turns

	def initialize(name)
		self.name = name
	end

	def add_to_score(score)
		self.score += score
	end

	def add_turn(score)
		self.turns << turn
	end

end

class DiceSet
  attr_accessor :values
  def roll (roll = 0)
    rolls = []
    (1..roll).each do
      rolls << rand(1..6)
    end
    self.values = rolls
  end
end



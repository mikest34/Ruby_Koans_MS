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

class InvalidPlayerNameError < RuntimeError
end

class Game

	attr_accessor :player_cnt
	attr_accessor :players
	attr_accessor :dice

	def initialize()
		self.players = []
		self.dice = DiceSet.new
	end

	def play
		# placeholder for executing all game logic
		collect_player_count
		collect_player_names
		
		while self.get_winner.score < 3000

			play_a_round

		end

		print "------------\n"
		print "Entering the final round\n"
		print "------------\n"
		display_score
		print "------------\n"

		play_a_round

		game_over

	end

	def game_over

		print "Game Over\n"
		print "And the winner is....\n"
		print "------------\n"
		print "#{get_winner.name}!\n"
		print "------------\n"
		print "Final scores:\n"
		display_score

	end

	def collect_player_count
		print "Enter the number of players\n"
		player_cnt = gets
		if player_cnt.to_i.is_a?(Integer) && player_cnt.to_i >= 2
			self.player_cnt = player_cnt.to_i
		else
			print "Invalid input, please try again\n"
			self.collect_player_count
		end
	end

	def collect_player_names
		(1..self.player_cnt).each do |x|
			print "Enter name for player #{x}:\n"
			player_name = gets
			begin
				self.add_player(player_name)
			rescue InvalidPlayerNameError
				print "Invalid input, please try again\n"
				self.collect_player_names
			end
		end
	end

	def add_player(name)
		self.players << Player.new(name)
	end

	def play_a_round

		self.players.each_with_index do |player,i|

			print "#{player.name}, it is your turn.\n"

			begin

				turn = GameTurn.new(player)
				turn.play

				break if self.get_winner.score < 3000

			rescue BustedError
				print "------------\n"
				print "BUSTED!\n"
				print "------------\n"
			end

		end

		print "Round Ended. The current score is\n"
		display_score

	end

	def display_score
		self.players.each_with_index do |x,i|
			print "#{x.name} (player #{(i+1)}): #{x.score} points\n"
		end
	end

	def get_winner
		self.players.max_by { |h| h.score }
	end

end

class GameTurn

	attr_accessor :player
	attr_accessor :rolls

	def initialize(player)
		self.player = player
		self.rolls = []
	end

	def play

		dice_left = 5
		continue_turn = false

		while dice_left > 0 do
			if dice_left < 5
				score = add_up_score
				print "You have #{dice_left} dice left over\n"
				print "Your score is currently #{score}\n"
				continue_turn = collect_continue_turn 
				break if ! continue_turn
			end

			dice_left = roll_the_dice(dice_left)
		end

		score = add_up_score
		print "Your score for that turn was #{score}\n"
		self.player.add_to_score(score)
		print "------------\n"

	end

	def add_up_score
		self.rolls.inject(0){|sum,x| sum + x }
	end

	def roll_the_dice(dice_left=5)

		dice = DiceSet.new
		dice_result = dice.roll(dice_left)
		print "Dice rolled: #{dice_result.to_a.join(", ")}\n"
		roll_score = self.score_the_roll(dice_result)

		if roll_score == 0
			raise BustedError
		end

		self.rolls << roll_score

		dice_left = self.count_dice_left(dice_result)

	end

	def collect_continue_turn

		print "Enter 'r' to roll remaining dice or 'q' to end the turn\n"
		choice = gets
		if choice.downcase[/r/]
			return true
		elsif choice.downcase[/q/]
			return false
		else
			print "I didn't understand that input. Try again\n"
			self.collect_continue_turn
		end

	end

	def count_dice_left(roll_result)
		dice_left = 0
		roll_summary = roll_result.inject(Hash.new(0)){|h,k| h[k] += 1;h}
		roll_summary.each do |k,v|
			dice_left += v if v < 3 && k != 1 && k != 5
		end
		dice_left
	end

	def score_the_roll(dice)

		roll_summary = dice.inject(Hash.new(0)){|h,k| h[k] += 1;h}
		score = 0
		roll_summary.each do |k,v|
			score += (k==1?1000:100)*k if v >= 3
			score += (v>=3?(v-3):v)*(k==1?100:50) if k == 1 || k == 5
		end
		score

	end

end

class Player
	attr_accessor :name
	attr_accessor :score
	attr_accessor :in_game

	def initialize(name)
		raise InvalidPlayerNameError if name.length < 3
		
		self.name = name[/[A-Za-z]+/]
		self.score = 0
		self.in_game = false

	end

	def add_to_score(score)
		self.is_in_game(score)
		self.score += score if self.in_game
		self.score
	end

	def is_in_game(score=0)
		if score >= 300
			self.in_game = true
		else 
			print "You must accumulate a score of 300 or more points before your score will count.\n"
		end
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

	def dice_left
		dice_left = 0
		self.values.each do |k,v|
			dice_left += v if v < 3 && k != 1 && k != 5
		end
		dice_left
	end

end

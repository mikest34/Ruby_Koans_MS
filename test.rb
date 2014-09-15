require File.expand_path(File.dirname(__FILE__) + '/about_extra_credit')

game = Game.new
game.player_cnt = 2
game.add_player("mike")
game.add_player("peggy")

turn = GameTurn.new(game.players[0])
turn.play

turn = GameTurn.new(game.players[1])
turn.play




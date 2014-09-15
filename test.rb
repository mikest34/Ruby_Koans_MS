require File.expand_path(File.dirname(__FILE__) + '/about_extra_credit')


game = Greed.new

game.player_cnt = 2
game.new_player('Mike')
game.new_player('Peggy')
game.display_score
game.watch_rounds

puts "test".to_i.is_a?(Integer)


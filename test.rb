class Map
	attr_accessor :tiles
	def initialize(filename)
		@file = File.read(filename).split(/\n/)
		@tiles = @file.map { |line| line.split(//) }
	end

	def to_s
		@tiles.map { |line| line.join }.join("\n")
	end
	
end

class Piece

	All_Pieces = ["^", "%", "#", "&"]
	
	def next_piece
    		All_Pieces.sample
  	end

end

class Game
	attr_accessor :map
	def initialize(level = 1)
		@score = 0
		@level = level
		@map = Map.new("map#{@level}.txt")
		@current_piece = Piece.new
		place_next
	end


	def move(input)
		row = @map.tiles.detect{|list| list.include?('@')}
		column = row.index('@')
		line = @map.tiles.index(row)
		keys = {'w' => [line - 1, column],
			's' => [line + 1, column],
			'a' => [line, column - 1],
			'd' => [line, column + 1]}		

		if keys.has_key?(input)
			position = @map.tiles[keys[input][0]][keys[input][1]]
			case position 
				when "*"
					message("*")
				when "|"
					message("|")
				else
					@map.tiles[keys[input][0]][keys[input][1]] = '@' 
					@map.tiles[line][column] = ' ' 
					update_score if position != " "
			end
		else
			message("i")
		end
		puts @map
		message("s")
	end

	private
	def message(m)
		case m
			when "*"	
				puts "Reached the eadge of map!"
			when "|"
				puts "You hit a wall!"
			when "i"
				puts "Invalid key"
			when "s"
				puts "Your score: #{@score}"
			when "l"
				puts "You reached level #{@level}"
			when "e"
				puts "End of Game!"
			else
				puts ""
		end
	end	

	def update_score
		@score += 1
		next_step
	end

	def next_step
		if @score < @level * 10
			place_next	
		else
			@level += 1			
			case @level 
				when 1..2
					message("l")
					@map = Map.new("map#{@level}.txt")
					place_next
				else
					#message("e")
			end	
		end
	end

	def place_next
		piece = @current_piece.next_piece
		x = rand(@map.tiles.size)
		y = rand(@map.tiles[x].size)
		if @map.tiles[x][y] == " "
			@map.tiles[x][y] = piece
		else
			place_next
		end	
	end
	
end


game = Game.new
puts game.map

input = gets.chomp
while input != 'q' do
	game.move(input)
	input = gets.chomp
end

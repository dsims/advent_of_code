filename = ARGV[0] || "input/test17.txt"
moves = File.readlines(filename, chomp: true).first.chars
grid =  Array.new(3){Array.new(7, '.')}
grid2 = Array.new(3){Array.new(7, '.')}
pieces = %q(
..@@@@.

...@...
..@@@..
...@...

....@..
....@..
..@@@..

..@....
..@....
..@....
..@....

..@@...
..@@...
).split("\n\n").collect{|p|p.split("\n").map(&:chomp).reject(&:empty?)}

def insert_piece grid, p
  blank = ".......".chars
  top = grid.index(blank)
  grid.pop(grid.length - 1 - top)
  grid.push blank.dup
  grid.push blank.dup
  p.reverse.each do |line|
    grid.push line.split('')
  end
end

def move_piece(grid, lowest, x, y)
  done = false
  test_grid = Marshal.load(Marshal.dump(grid))
  catch :done do
    (lowest.min..test_grid.size-1).to_a.each do |row|
      range = x < 0 ? (0..6).to_a : (0..6).to_a.reverse
      range.each do |col|
        new_row = row+y
        new_col = col+x
        next unless grid[row][col] == "@"
        return false if new_col < 0 || new_col >= 7
        if done || new_row < 0 || test_grid[new_row][col] == "#" #vertical stop
          done = true
          lowest[col] = row
          throw :done
          test_grid[row][col] = "#"
        else
          return nil if grid[new_row][new_col] == "#"
          test_grid[row][col] = "."
          test_grid[new_row][new_col] = "@"
        end
      end
    end
  end
  if done
    return true
  else
    test_grid.each_with_index do |row, i|
      grid[i] = row
    end
  end
  return false
end

def push_piece grid, lowest, dir
  case dir
    when ">" then move_piece(grid, lowest, 1, 0)
    when "<" then move_piece(grid, lowest, -1, 0)
  end
  result = move_piece(grid, lowest, 0, -1)
  result
end

def print_grid grid
  grid.reverse.each{|g|puts g.join('')}
  puts
end

def tetris(pieces, grid, moves, target)
  piece = 0
  remaining_moves = 0
  cycles = 0
  tallest = 0
  lowest = Array.new(7, 0)
  states = {}
  insert_piece(grid, pieces[piece])  
  loop do
    moves.each_with_index do |m, i|
      if push_piece(grid, lowest, m) #true means hit bottom
        piece += 1
        #scan upwards turning the added piece to a stuck piece
        grid.each_index do |row|
          grid[row].each_index do |col|
            next unless grid[row][col] == "@"
            grid[row][col] = "#"
            #track the lowest you can go in each column
            lowest[col] = row
          end
        end
        min = lowest.min
        if min > 0 #dropped rocks in all columns
          tallest += min #set the new "bottom" level
          grid.shift(min) #remove everything below
          $lowest = lowest.map!{|l|l - min } #adjust the tracked columns accordingly
          state = "#{lowest.dup}-#{piece % 5}-#{i}" #keep track of every unique combo of col-heights, piece, and move
          if cycles == 0
            if states[state] #pattern found!
              #find the values changed since pattern started
              pattern_height = tallest - states[state][:tallest]
              #pattern_moves = ((states.keys.size - 1) - states.keys.index(state)) 
              pattern_pieces = piece - states[state][:pieces]
              remaining_pieces = (target - piece)
              cycles = (remaining_pieces / pattern_pieces)
              #skip ahead
              piece += (pattern_pieces * cycles)
              tallest += pattern_height * cycles
            else
              states[state] = {tallest: tallest, pieces: piece}
            end
          end
        end
  
        #print_grid grid
        if piece == target
          #print_grid grid
          return tallest + lowest.max + 1
        end
        p = pieces[piece % 5]
        insert_piece(grid, p)
        #print_grid grid
      end
      #print_grid grid
    end
  end
end

part1 = tetris(pieces, grid, moves, 2022)
part2 = tetris(pieces, grid2, moves, 1000000000000)

puts "Part1: #{part1}. Part2: #{part2}."

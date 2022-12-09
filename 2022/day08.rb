filename = ARGV[0] || "input/test08.txt"
trees = []
File.readlines(filename, chomp: true).each_with_index do |line, i|
  trees << line.chars.map(&:to_i)
end
rows = trees.length - 1
cols = trees.first.length - 1
tallest = Array.new(rows+1){Array.new(cols+1)}
scenics = Array.new(rows+1){Array.new(cols+1, 1)}
(1..rows-1).each do |row|
  (1..cols-1).each do |col|
    tree = trees[row][col]
    tallest[row][col] = tree if (0..row-1).all?{ |up| trees[up][col] < tree } ||
                             (row+1..rows).all?{ |dn| trees[dn][col] < tree } ||
                                (0..col-1).all?{ |lt| trees[row][lt] < tree } ||
                             (col+1..cols).all?{ |rt| trees[row][rt] < tree }

    scenics[row][col] *= row - (row-1).downto(0).find{ |up| trees[up][col] >= tree }.to_i
    scenics[row][col] *=          ((row+1..rows).find{ |dn| trees[dn][col] >= tree } || rows) - row
    scenics[row][col] *= col - (col-1).downto(0).find{ |lt| trees[row][lt] >= tree }.to_i
    scenics[row][col] *=          ((col+1..cols).find{ |rt| trees[row][rt] >= tree } || cols) - col
  end
end
borders_num = (rows + cols) * 2
tallest_num = tallest.flatten.compact.size
most_scenic = scenics.flatten.compact.max
puts "Part 1: #{tallest_num + borders_num}. Part 2: #{most_scenic}"
puts tallest.map { |a| a.map { |i| i ? '🌲' : '🌱' }.join } # display map of trees
puts scenics.map { |a| a.map { |i| i == most_scenic ? '🎄' : i > most_scenic / 4 ? '🌲' : '🪨' }.join }

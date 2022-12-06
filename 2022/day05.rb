filename = ARGV[0] || "input/test05.txt"
rows = length = 0
File.readlines(filename, chomp: true).each do |line|
  break if line[1] == "1"
  length = line.length if line.length > length
  rows += 1
end
cols = (length + 1) / 4
stacks = Array.new(cols){Array.new}
File.readlines(filename, chomp: true).take(rows).reverse.each do |line|
  line = line.ljust(length)
  col = 0
  (1..length).step(4) do |i|
    letter = line[i]
    stacks[col].push letter if letter != " "
    col += 1
  end
end
stacks_9001 = stacks.map(&:clone)
File.readlines(filename, chomp: true).drop(rows+2).each do |line|
  num, from, to = line.scan(/\d+/).map(&:to_i)
  num.times do
    stacks[to-1].push stacks[from-1].pop
  end
  stacks_9001[to-1].concat stacks_9001[from-1].pop(num)
end
part1, part2 = [stacks, stacks_9001].collect{|s| s.collect{|s|s.last}.join }
puts "part1: #{part1} part2: #{part2}"

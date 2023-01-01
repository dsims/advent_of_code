filename = ARGV[0] || "input/test23.txt"
grove = []
elves = []
elves2 = []
File.readlines(filename, chomp: true).each_with_index do |line, i|
  chars = line.chars
  grove << chars
  cols = chars.each_index.select{|i| chars[i] == "#"}
  elves  += cols.map{|c| [i, c]}
  elves2 += cols.map{|c| [i, c]}
end

def north?(elves, elf)
  r = -1
  erow, ecol = elf
  found = false
  [0,1,-1].each do |c|
    d = [erow + r, ecol + c]
    found = true if elves.include?(d)
  end
  return [erow + r, ecol] if !found
end
def south?(elves, elf)
  r = 1
  erow, ecol = elf
  found = false
  [0,1,-1].each do |c|
    d = [erow + r, ecol + c]
    found = true if elves.include?(d)
  end
  return [erow + r, ecol] if !found
end
def west?(elves, elf)
  c = -1
  erow, ecol = elf
  found = false
  [0,-1,1].each do |r|
    d = [erow + r, ecol + c]
    found = true if elves.include?(d)
  end
  return [erow, ecol + c] if !found
end
def east?(elves, elf)
  c = 1
  erow, ecol = elf
  found = false
  [0,-1,1].each do |r|
    d = [erow + r, ecol + c]
    found = true if elves.include?(d)
  end
  return [erow, ecol + c] if !found
end

def open?(elves, elf, order)
  results = []
  order.each do |o|
    result = case o
      when "N" then north?(elves, elf)
      when "S" then south?(elves, elf)
      when "W" then west?(elves, elf)
      when "E" then east?(elves, elf)
    end
    results << result if result
  end
  results
end

rounds = 10
order = ["N","S","W","E"]
rounds.times do |round|
  puts "Round #{round}"
  desired = Hash.new{|h,k|h = []}
  elves.each_with_index do |elf, i|
    results = open?(elves, elf, order)
    next if results.size == 4 || results.size == 0
    to = results.first
    desired[to] = desired[to] + [i]
  end
  desired.each do |k,v|
    next if v.size > 1
    elves[v[0]] = k
  end
  order.rotate!
end
#pp elves
min_row, max_row = elves.collect{|e|e[0]+1}.minmax
min_col, max_col = elves.collect{|e|e[1]+1}.minmax
min_row -= 1 if (min_row < 1)
min_col -= 1 if (min_col < 1)
ground = (max_row - min_row) * (max_col - min_col) - elves.size
puts "Part1: #{ground}"

return #taking too long

round = rounds
done = false
while done == false
  puts "Round #{round}"
  desired = Hash.new{|h,k|h = []}
  elves.each_with_index do |elf, i|
    results = open?(elves, elf, order)
    next if results.size == 4 || results.size == 0
    to = results.first
    desired[to] = desired[to] + [i]
  end
  done = true if desired.size == 0
  desired.each do |k,v|
    next if v.size > 1
    elves[v[0]] = k
  end
  order.rotate!
  round += 1
end

puts "Part2: #{round}"

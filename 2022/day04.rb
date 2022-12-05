filename = ARGV[0] || "input/test04.txt"
part1 = part2 = 0
File.readlines(filename, chomp: true).each do |pair|
  e1, e2 = pair.split(',').map!{|e|e.split('-').map!{|i|i.to_i}}
  contained = (e1[0] <= e2[0] && e1[1] >= e2[1]) || (e2[0] <= e1[0] && e2[1] >= e1[1])
  part1 += 1 if contained
  part2 += 1 if contained || (e1[0] <= e2[0] && e1[1] >= e2[0]) || (e2[0] <= e1[0] && e2[1] >= e1[0])
end
puts "Pairs: part1: #{part1} part2: #{part2}"

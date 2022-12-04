filename = ARGV[0] || "input/test03.txt"
def char_val c
  val = (c.ord - "a".ord) + 1 #1-26, uppercase will be negative
  val += val < 0 ? ("a".ord - "A".ord) + 26 : 0 #adjust A-Z
end
part1 = File.readlines(filename, chomp: true).collect do |rs|
  mid = rs.length/2
  c = (rs.slice(0, mid).chars & rs.slice(mid, rs.length).chars).first
  char_val c
end.sum
part2 = File.readlines(filename, chomp: true).each_slice(3).collect do |sacks|
  sacks = sacks.collect{|s|s.chars}
  c = (sacks[0] & sacks[1] & sacks[2]).first
  char_val c
end.sum
puts "Priority sums: part1: #{part1} part2: #{part2}"

filename = ARGV[0] || "input/test06.txt"
def find_marker line, marker_size
  chars = line.chars
  index = (0..line.length-1).each.find do |i|
    chars.slice(i,marker_size).uniq.length == marker_size
  end
  index + marker_size
end
File.readlines(filename, chomp: true).each_with_index do |line, i|
  part1 = find_marker(line, 4)
  part2 = find_marker(line, 14)
  puts "Line #{i}: Packet Marker: #{part1}  Message Marker: #{part2}"
end

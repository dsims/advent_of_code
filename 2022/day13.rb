require 'json'
filename = ARGV[0] || "input/test13.txt"

def compare left, right
  if left.is_a?(Integer) && right.is_a?(Integer)
    return left <=> right
  end
  if left.is_a?(Array) && right.is_a?(Array)
    left.each_with_index do |l,i|
      return 1 if right.length == i
      return -1 if compare(l, right[i]) == -1
      return 1 if compare(l, right[i]) == 1
    end
    return 0 if left == right
    return -1
  end
  left = [left] if right.is_a?(Array) && !left.is_a?(Array)
  right = [right] if left.is_a?(Array) && !right.is_a?(Array)
  return compare(left, right)
end

part1 = 0
idx = 0
packets = []
File.readlines(filename, chomp: true).each_slice(3) do |lines|
  idx += 1
  packet1, packet2 = lines
  left  = JSON.load(packet1)
  right = JSON.load(packet2)
  packets << left
  packets << right
  part1 += idx if compare(left, right) == -1
end

dividers = [[[2]], [[6]]]
packets.concat(dividers).sort! do |left, right|
  compare(left, right)
end
part2 = (packets.index(dividers[0]) + 1) * (packets.index(dividers[1]) + 1)

puts "Part1: #{part1} Part2: #{part2}"

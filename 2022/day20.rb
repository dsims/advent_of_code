filename = ARGV[0] || "input/test20.txt"
initial_part1 = []; initial_part2 = [];
numbers_part1 = []; numbers_part2 = [];
File.readlines(filename, chomp: true).each_with_index do |line, i|
  val = line.to_i
  initial_part1 << val
  numbers_part1 << {i: i, val: val}
  val = val * 811589153
  initial_part2 << val
  numbers_part2 << {i: i, val: val}
end
$size = initial_part1.size
#pp initial_part1

def mixing(initial, numbers)
  initial.each_with_index do |n,i|
    idx = numbers.index{|num|num[:i]==i}
    next if n == 0
    to = idx + n
    to = ((idx + n) % ($size-1))
    to -= 1 if to == 0
    numbers.insert(to, numbers.delete_at(idx))
  end
  #pp numbers
end

def calculate_result numbers
  zero = numbers.index{|num| num[:val] == 0 }
  [
    numbers[(1000 + zero) % $size][:val],
    numbers[(2000 + zero) % $size][:val],
    numbers[(3000 + zero) % $size][:val]
  ]
end

mixing(initial_part1, numbers_part1)
result = calculate_result(numbers_part1)
puts "Part1: #{result} = #{result.sum}"

10.times do
  mixing(initial_part2, numbers_part2)
end
result = calculate_result(numbers_part2)
puts "Part2: #{result} = #{result.sum}"

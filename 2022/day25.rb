filename = ARGV[0] || "input/test25.txt"
VALUES = {
  '2' => 2,
  '1' => 1,
  '0' => 0,
  '-' => -1,
  '=' => -2
}
nums = []
File.readlines(filename, chomp: true).each_with_index do |snafu, i|
  sum = 0
  snafu.chars.reverse.each_with_index do |char, power|
    val = VALUES[char]
    sum += val * (5**power)
  end
  nums << sum
end
total = nums.sum
pp nums
pp nums.sum
snafu = ''
# 15 = [3,0] "0" > [0, 3] "=" > [0,1] "1" = 0=1 > 1=0
div = total
while div > 0
  div, rem = div.divmod(5) #divisible by 5 with remainder
  case rem
  when 0, 1, 2
    snafu += rem.to_s
  when 3
    div += 1
    snafu += '='
  when 4
    div += 1
    snafu += '-'
  end
end
puts snafu.reverse

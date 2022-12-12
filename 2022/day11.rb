filename = ARGV[0] || "input/test11.txt"
define_method(:monkey_biz) do |part, rounds|
  monkeys = File.readlines(filename, chomp: true).each_slice(7).collect do |lines|
    {
      holding: lines[1].scan(/\d+/).map(&:to_i),
      operation: lines[2].split(' ')[4..],
      test: lines[3].scan(/\d+/).map(&:to_i).first,
      true_monkey: lines[4].scan(/\d+/).map(&:to_i).first,
      false_monkey: lines[5].scan(/\d+/).map(&:to_i).first,
      inspected: 0
    }
  end
  #since these are apparently all prime numbers, the lcm is just the product of them all
  lcm = monkeys.collect{|m|m[:test]}.reduce(&:lcm) 
  rounds.times do
    monkeys.each do |monkey|
      monkey[:holding].each do |item|
        op, val = monkey[:operation]
        val = (val == "old") ? item : val.to_i
        new_item = case op
          when '*' then item * val
          when '+' then item + val
        end
        new_item = new_item / 3 if part == 1
        new_item = new_item % lcm if part == 2 # same as ((item % lcm) [+ or *] (val % lcm))
        pass_to = new_item % monkey[:test] == 0 ? monkey[:true_monkey] : monkey[:false_monkey]
        monkeys[pass_to][:holding].push new_item
      end
      monkey[:inspected] += monkey[:holding].size
      monkey[:holding].clear
    end
  end
  monkeys.collect{|m|m[:inspected]}.sort.last(2).inject(:*).to_s
end
puts "Part1: #{monkey_biz(1, 20)}. Part2: #{monkey_biz(2, 10000)}"

filename = ARGV[0] || "input/test01.txt"
total = 0
elves = []
(f = File.open(filename)).each_line do |line|
  line.chomp!
  if line == "" || f.eof?
    elves << total + line.to_i
    total = 0
  else
    total += line.to_i
  end
end
top3 = elves.sort.reverse.take(3)
puts "SUM is #{top3.sum} from highest 3 #{top3} of #{elves.count} elves."

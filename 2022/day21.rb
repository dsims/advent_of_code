filename = ARGV[0] || "input/test21.txt"
monkeys = {}
File.readlines(filename, chomp: true).each_with_index do |line, i|
  monkey, job = line.split(": ")
  yell = job.to_i if Float(job) rescue false
  if yell
    monkeys[monkey] = {yell: yell}
  else
    job = job.split(' ')
    monkeys[monkey] = {yell: nil, wait1: job[0], math: job[1], wait2: job[2]}
  end
end

$monkeys = monkeys
def compute(monkey)
  return monkey[:yell] if monkey[:yell]
  wait1 = compute($monkeys[monkey[:wait1]])
  wait2 = compute($monkeys[monkey[:wait2]])
  return case monkey[:math]
    when "+" then wait1 + wait2
    when "-" then wait1 - wait2
    when "*" then wait1.to_f * wait2.to_f
    when "/" then wait1.to_f / wait2.to_f
    when "=" then [wait1, wait2]
  end
end

result = compute($monkeys["root"])
puts "Part1: #{result}"

min = 0
max = 10000000000000
$monkeys["root"][:math] = "="
result = nil
until result
  mid = ((min + max) / 2).floor
  $monkeys["humn"][:yell] = mid
  wait1, wait2 = compute($monkeys["root"])
  result = mid if wait1 == wait2
  max = mid if wait1 < wait2 #have to swap min and max for the real data.
  min = mid if wait1 > wait2
end
puts "Part2: #{result}"
return

#original part1 solution calculating as we go 
until monkeys['root'][:yell]
  yelling = monkeys.select{|k,m| m[:yell]}
  wait1 = monkeys.select{|k,m| yelling.keys.include?(m[:wait1]) }
  wait1.each do |k,w|
    w[:wait1] = yelling[w[:wait1]][:yell]
  end
  wait2 = monkeys.select{|k,m| yelling.keys.include?(m[:wait2]) }
  wait2.each do |k,w|
    w[:wait2] = yelling[w[:wait2]][:yell]
  end
  monkeys.delete_if {|k, v| yelling.keys.include?(k) }
  done = monkeys.select{|k,m| m[:wait1].is_a?(Integer) && m[:wait2].is_a?(Integer) }
  done.each do |k,m|
    m[:yell] = case m[:math]
      when "+" then m[:wait1] + m[:wait2]
      when "-" then m[:wait1] - m[:wait2]
      when "*" then m[:wait1] * m[:wait2]
      when "/" then m[:wait1] / m[:wait2]
    end
    m[:wait1] = m[:wait2] = nil
  end
end
puts monkeys['root'][:yell]

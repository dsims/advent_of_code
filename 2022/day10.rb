filename = ARGV[0] || "input/test10.txt"
cyc = 0
reg = 1
part1_cycles = [20, 60, 100, 140, 180, 220]
part2_cycles = [40, 80, 120, 160, 200, 240]
part1_results = []
part2_results = ""
sprite_pos = [0,1,2]
define_method(:run_cycle) do
  cyc += 1
  part1_results.push(cyc * reg) if part1_cycles.include?(cyc)
  pixel = cyc - (40 * (cyc / 40)) - 1
  part2_results += sprite_pos.include?(pixel) ? "#" : "."
end
File.readlines(filename, chomp: true).each_with_index do |line, i|
  instruction, value = line.split(' ')
  run_cycle
  next if instruction == "noop"
  run_cycle
  reg += value.to_i
  sprite_pos.map!{|p| p + value.to_i }
end
puts part1_results.sum
puts part2_results.scan(/.{40}/)

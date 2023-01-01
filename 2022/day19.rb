filename = ARGV[0] || "input/test19.txt"
blueprints = []
robots = {ore: 1, clay: 0, obsidian: 0, geode: 0}
collect = {ore: 0, clay: 0, obsidian: 0, geode: 0}
$seen = {}
$max = 0

File.readlines(filename, chomp: true).each_with_index do |line, i|
  id, ore_ore, clay_ore, obsidian_ore, obsidian_clay, geode_ore, geode_obsidian = line.scan(/\d+/).map(&:to_i)
  blueprints << {
    stats: {id: id, ore: {ore: ore_ore, clay: 0, obsidian: 0}, clay: {ore: clay_ore, clay: 0, obsidian: 0}, obsidian: {ore: obsidian_ore, clay: obsidian_clay, obsidian: 0}, geode: {ore: geode_ore, clay: 0, obsidian: geode_obsidian}},
    collect: {ore: 0, clay: 0, obsidian: 0, geode: 0},
    robots: {ore: 1, clay: 0, obsidian: 0, geode: 0}
  }
end

def dfs(stats, robots, collect, time, state)
  if time == 0
    if collect[:geode] >= $max
      $max = collect[:geode]
    end
    return collect[:geode]
  end

  max_geodes_left = collect[:geode]
  time.times do |i|
    max_geodes_left += robots[:geode] + i
  end
  if max_geodes_left <= $max
    return collect[:geode]
  end

  possibilities = []

  max_robots = [:ore, :clay, :obsidian].collect{|r| [:ore, :clay, :obsidian, :geode].collect{|k| stats[k][r]}.max }
  max_robots = {ore: max_robots[0], clay: max_robots[1], obsidian: max_robots[2]}

  perms = (robots.keys - [:geode]).permutation(3)
  perms.each do |keys|
    keys = [:geode] + keys
    wallet = collect.dup
    bots = robots.dup
    keys.each do |k|
      next if k != :geode && bots[k] >= max_robots[k]
      if [:ore, :clay, :obsidian].all?{|m,i| wallet[m] >= stats[k][m]}
        bots[k] += 1
        [:ore, :clay, :obsidian].each{|m,i| wallet[m] -= stats[k][m]}
        break
      end
    end
    robots.each do |k,r|
      wallet[k] += r
    end
    possibilities << {robots: bots, collect: wallet}
  end

  robots.each do |k,r|
    collect[k] += r
  end
  possibilities << {robots: robots, collect: collect} #do nothing

  possibilities.uniq!
  results = possibilities.collect do |p|
    hash_key = p[:robots].values.to_s+p[:collect].values.to_s+(time-1).to_s
    if $seen[hash_key]
      $seen[hash_key] 
    else
      $seen[hash_key] = dfs(stats, p[:robots], p[:collect], time-1, state + [hash_key])
    end
  end
  results.max
end

part1_results = blueprints.collect do |b|
  next
  result = dfs(b[:stats], {ore: 1, clay: 0, obsidian: 0, geode: 0}, {ore: 0, clay: 0, obsidian: 0, geode: 0}, 24, [])
  puts "Blueprint #{b[:stats][:id]}: #{result}. Seen #{$seen.size}"
  $seen = {}
  $max = 0
  result
end
quality = part1_results.compact.each_with_index.collect{|r,i| r*(i+1)}.sum
puts "Part1: #{quality}"

part2_results = blueprints.collect do |b|
  next unless b[:stats][:id] <= 3
  result = dfs(b[:stats], {ore: 1, clay: 0, obsidian: 0, geode: 0}, {ore: 0, clay: 0, obsidian: 0, geode: 0}, 32, [])
  puts "Blueprint #{b[:stats][:id]}: #{result}. Seen #{$seen.size}"
  $seen = {}
  $max = 0
  result
end
puts "Part2: #{part2_results.compact.inject(:*)}"

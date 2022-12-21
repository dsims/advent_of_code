filename = ARGV[0] || "input/test16.txt"
$valves = {}
$best = 0

File.readlines(filename, chomp: true).each_with_index do |line, i|
  words = line.split(' ')
  valve = words[1]
  rate = words[4].split('=')[1].chomp(';').to_i
  lead_to = words[9..-1].map{|w|w.chomp(',')}
  $valves[valve] = {rate: rate, to: lead_to}
end
# pp $valves

$distances = {}
def get_dist(from, to)
  # get number of hops to reach destination
  return $distances[from][to] if $distances.dig(from, to)
  # calculate as needed and cache
  to_a = [to]
  dist = 0
  until to_a.include?(from)
    to_next = []
    to_a.each do |to|
      to_next += $valves.filter {|k,v| v[:to].include?(to) }.keys
    end
    to_a = to_next.uniq
    dist += 1
  end
  $distances[from] ||= {}
  $distances[from][to] = dist
  return dist
end

#only care about valves that release
$useful_valves = $valves.filter {|k,v| v[:rate] > 0 }.sort_by{|k, v| v[:rate] * -1 }.to_h
def dfs(minute_rem=30, pos="AA", opened=[], released=0, paths={})
  $useful_valves.keys.each do |v|
    next if pos == v || opened.include?(v)
    dist = get_dist(pos, v)
    rem = minute_rem-dist-1
    next if rem < 1
    to_release = released + (rem * $valves[v][:rate])
    $best = [$best, to_release].max
    new_opened = (opened + [v]).sort #sort to reduce unique paths
    paths[new_opened] = paths.key?(new_opened) ? [paths[new_opened], to_release].max : to_release
    #next if (estimate_remaining(new_opened, rem) + to_release) < $best #optimization
    dfs(rem, v, new_opened, to_release, paths)
  end
  paths
end

dfs()
puts "part1: #{$best}"

#find every set of opened values and its max score
opened_valves = dfs(26)
#build every combination of sets of values, where each set has unique valves
combos = opened_valves.to_a.combination(2).filter{|c1,c2| (c1[0] & c2[0]).empty? && c1[1] && c2[1]}
#find the combination of sets with the highest total score
best2 = combos.collect{|c1,c2| c1[1]+c2[1]}.max
puts "part2: #{best2}"

filename = ARGV[0] || "input/day18.txt"
cubes = []
$sets = [
  Hash.new { |h, k| h[k] = [] },
  Hash.new { |h, k| h[k] = [] },
  Hash.new { |h, k| h[k] = [] }
]
$max = [0,0,0]
$min = [Float::INFINITY,Float::INFINITY,Float::INFINITY]
File.readlines(filename, chomp: true).each_with_index do |line, i|
  cube = line.split(',').map(&:to_i)
  $sets[0][cube[0]] << [cube[1], cube[2]]
  $sets[1][cube[1]] << [cube[0], cube[2]]
  $sets[2][cube[2]] << [cube[0], cube[1]]
  [0,1,2].each do |i|
    $min[i] = [$min[i], cube[i]].min
    $max[i] = [$max[i], cube[i]].max
  end
  cubes << cube
end

def num_touching cube1, xyz
  touching = 0
  check = [0,1,2] - [xyz]
  [-1,1].each do |i|
    next if !$sets[xyz][cube1[xyz]+i]
    $sets[xyz][cube1[xyz]+i].each do |cube2|
      touching += 1 if [cube1[check[0]], cube1[check[1]]] == cube2
    end
  end
  return touching
end

total_touching = 0
cubes.each do |cube|
  [0,1,2].each do |xyz|
    total_touching += num_touching cube, xyz
  end
end

puts "Part1: #{(cubes.size * 6) - total_touching}"

#BFS
queue = [[0,0,0]]
seen = []
outsides = 0
until queue.empty? do
  pos = queue.shift
  next if seen.include?(pos)
  seen << pos
  [0,1,2].each do |xyz|
    [1,-1].each do |dir|
      next if dir == -1 && pos[xyz] <= $min[xyz] - 1
      next if dir ==  1 && pos[xyz] >= $max[xyz] + 1
      check = pos.dup
      check[xyz] = check[xyz] + dir
      if (cubes.include? check)
        outsides += 1
      elsif !seen.include?(check)
        queue.push(check)
      end
    end
  end
end

puts "Part2: #{outsides}"
return

#first attempted to ray-trace to find all interior points but gets wrong answer
inside_cubes = []
[0,1,2].each do |xyz|
  aa,bb = [0,1,2] - [xyz]
  ($min[aa]-1..$max[aa]+1).to_a.each do |a|
    ($min[bb]-1..$max[bb]+1).to_a.each do |b|
      line = Array.new(($max[xyz])-($min[xyz])+3, ".")
      ($min[xyz]..$max[xyz]+2).to_a.each do |c|
        next if $sets[xyz][c].include?([a,b])
        hits = hits2 = 0
        prev = c-1
        (c..$max[xyz]+1).to_a.each do |c2|
          if $sets[xyz][c2].include?([a,b]) && !$sets[xyz][prev].include?([a,b])
            hits +=1
          end
          prev = c2
        end
        prev = c+1
        ($min[xyz]-1..c).to_a.reverse.each do |c2|
          if $sets[xyz][c2].include?([a,b]) && !$sets[xyz][prev].include?([a,b])
            hits2 +=1
          end
          prev = c2
        end
        if hits.odd? && hits2.odd? && !$sets[xyz][c].include?([a,b])
          inside_cubes << [c,a,b] if xyz == 0
          inside_cubes << [a,c,b] if xyz == 1
          inside_cubes << [a,b,c] if xyz == 2
        end
      end
    end
  end
end
inside_cubes = inside_cubes.select{ |e| inside_cubes.count(e) > 2 }.uniq
inside_touching = 0
inside_cubes.each do |cube|
  [0,1,2].each do |xyz|
    inside_touching += num_touching cube, xyz
  end
end

puts "Part2?: #{(cubes.size * 6) - total_touching - inside_touching}"


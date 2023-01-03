filename = ARGV[0] || "input/test24.txt"
valley = []
$forecast = []
bz_l = []
bz_r = []
File.readlines(filename, chomp: true).each_with_index do |line, i|
  chars = line.chars
  valley << chars
  bz_l << chars.map{|c| c == "<" ? "<" : nil} #rows of cols
  bz_r << chars.map{|c| c == ">" ? ">" : nil}
end
bz_l = bz_l.map{|a|a[1..-2]}[1..-2]
bz_r = bz_r.map{|a|a[1..-2]}[1..-2]
bz_u = Array.new(bz_l.first.size){Array.new(bz_l.size)}
bz_d = Array.new(bz_l.first.size){Array.new(bz_l.size)}
valley[1..-2].each_with_index do |chars, i|
  chars[1..-2].each_with_index.select{|c,k|
    bz_u[k][i] = (c == "^" ?  "^" : nil)#cols of rows
    bz_d[k][i] = (c == "v" ?  "v" : nil)
  }
end

$start = [0,0]
$stop = [bz_l.size,valley.last.index(".")-1]
$best_time = Float::INFINITY

def move_blizzards bz_l, bz_r, bz_d, bz_u
  [
    bz_l.map(&:rotate),
    bz_r.map{|i|i.rotate(-1)},
    bz_d.map{|i|i.rotate(-1)},
    bz_u.map(&:rotate)
  ]
end

$forecast << [bz_l, bz_r, bz_d, bz_u]
#(bz_l.size * bz_l.first.size).times do |t|
#  bz_l, bz_r, bz_d, bz_u = move_blizzards bz_l, bz_r, bz_d, bz_u
#  $forecast << [bz_l, bz_r, bz_d, bz_u]
#end

def is_blizzard row, col, time
  #t = time % ($forecast.first.first.size * $forecast.first.first.first.size)
  #bz_l, bz_r, bz_d, bz_u = $forecast[t]
  if $forecast.size == time
    #generate and cache positions at time
    bz_l, bz_r, bz_d, bz_u = $forecast.last
    $forecast << move_blizzards(bz_l, bz_r, bz_d, bz_u)
  end
  bz_l, bz_r, bz_d, bz_u = $forecast[time]
  bliz = bz_l[row][col] ||
    bz_r[row][col] ||
    bz_u[col][row] ||
    bz_d[col][row]
  bliz
end

best_time = Float::INFINITY
max_time = 0
queue = []
queue.push([$start.dup, 1, []])
seen = []

#BFS
while(queue != nil && queue != []) do
  pos, time, path = queue.shift
  row, col = pos
  next if is_blizzard row, col, time
  #stop if impossible to get to end in less time
  next if ((time + ($stop[0] - row) + ($stop[1] - col)) > best_time)
  if time > max_time
    #just to show progress
    max_time = time
    print " #{max_time}-#{queue.size}"
  end
  #try left & right
  [-1,1].each do |r|
    new_row = row+r
    new_pos = [new_row, col]
    if new_pos == $stop
      if time < best_time
        best_time = time
        puts "best #{best_time}"
      end
      next
    end
    #out of bounds
    next if new_row < 0 || new_row >= $forecast.first.first.size
    if !is_blizzard(new_row, col, time+1) && !seen.include?(new_pos+[time+1])
      seen << new_pos+[time+1]
      queue.push([new_pos, time+1, path + [new_pos]])
    end
  end
  #try up & down
  [-1,1].each do |c|
    new_col = col+c
    next if new_col < 0 || new_col >= $forecast.first.first.first.size
    new_pos = [row, new_col]
    if !is_blizzard(row, new_col, time+1) && !seen.include?(new_pos+[time+1])
      seen << new_pos+[time+1]
      queue.push([new_pos, time+1, path + [new_pos]])
    end
  end
  #try waiting
  if !is_blizzard(row, col, time+1) && !seen.include?(pos+[time+1])
    seen << pos+[time+1]
    queue.push([pos.dup, time+1, path + ['wait']])
  end
end

puts "Part 1: #{best_time + 1}"

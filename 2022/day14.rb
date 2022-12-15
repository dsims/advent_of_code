filename = ARGV[0] || "input/test14.txt"
paths = []
deepest = rightest = 0
leftest = 1000
File.readlines(filename, chomp: true).each_with_index do |line, i|
  path = line.split(" -> ").collect{|point| point.split(",").map(&:to_i)}
  leftest = (path.collect{|p|p[0]} << leftest).min
  rightest = (path.collect{|p|p[0]} << rightest).max
  deepest = (path.collect{|p|p[1]} << deepest).max
  paths << path
end
define_method(:adjusted) do |point|
  x,y = point
  [x - leftest, y]
end
define_method(:build_cave) do |grid|
  paths.each do |path|
    path.each_with_index do |point, i|
      x1,y1 = adjusted(point)
      grid[y1][x1] = "#"
      if i+1 < path.length
        x2,y2 = adjusted(path[i+1])
        if x1 != x2
          range = (x1..x2) if x2 > x1
          range = (x2..x1) if x1 > x2
          range.to_a.each do |x|
            grid[y1][x] = "#"
          end
        end
        if y1 != y2
          range = (y1..y2) if y2 > y1
          range = (y2..y1) if y1 > y2
          range.each do |y|
            grid[y][x1] = "#"
          end
        end
      end
    end
  end
  grid
end
def move_sand grid, sand, start
  y = sand[:y] + 1
  return nil if y == grid.length
  if grid[y][sand[:x]] == '.'
    return {x: sand[:x], y: y}
  end
  x = sand[:x] - 1
  return nil if x < 0
  return {x: x, y: y} if grid[y][x] == '.'
  x = sand[:x] + 1
  return nil if x == grid[0].length
  return {x: x, y: y} if grid[y][x] == '.'
  return nil if sand[:x] == start[0] && sand[:y] == start[1]
  grid[sand[:y]][sand[:x]] = "o"
  return {x: start[0], y: start[1]}
end
def print_grid grid
  puts grid.collect(&:join) << "\n"
end

start_point = [500,0]
define_method(:simulate) do |grid|
  grains = 0
  start = adjusted(start_point)
  sand = {x: start[0], y: start[1]}
  while sand != nil do
    sand = move_sand(grid, sand, start)
    grains += 1 if sand && sand[:x] == start[0] && sand[:y] == start[1]
  end
  return grains
end

width = rightest - leftest
grid = build_cave Array.new(deepest+1){Array.new(width+1, '.')}
print_grid grid
part1 = simulate grid
print_grid grid

# probably not the best way to get the new grid size but it worked
# was too big to print anyways
leftest = leftest - deepest
rightest = rightest + deepest
width = rightest - leftest
grid = build_cave Array.new(deepest+3){Array.new(width+deepest, '.')}
grid[grid.length-1] = Array.new(width+deepest, '#') # add floor
part2 = simulate grid

puts "Part 1: #{part1} grains. Part 2: #{part2} grains"

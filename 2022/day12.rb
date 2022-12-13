filename = ARGV[0] || "input/test12.txt"
sY = sX = 0
eY = eX = 0
starts = []
grid = []

File.readlines(filename, chomp: true).each_with_index do |line, row|
  grid << line.chars
  e_col = line.index('E')
  s_col = line.index('S')
  eY, eX = [row, e_col] if e_col
  sY, sX = [row, s_col] if s_col
  line.chars.each_with_index do |c,i|
    starts.push [row, i, c] if c == 'a' || c == 'S'
  end
end

def valid(grid, visited, from_row, from_col, row, col)
  return false if row < 0 || row >= grid.length || col < 0 || col >= grid.first.length
  from = grid[from_row][from_col]
  to = grid[row][col]
  from = (from == 'S') ? 'a' : from
  to = (to == 'E') ? 'z' : to
  (to.ord - from.ord <= 1) && (visited[row][col] == 0)
end

def bfs(grid, sY, sX, eY, eX)
  nodes = []
  visited = Array.new(grid.size){Array.new(grid.first.length,0)}
  visited[sY][sX] = 1
  nodes.push([sY,sX,0,[grid[sY][sX]]])
  min_dist = Float::INFINITY
  while(nodes != nil && nodes != []) do
    nY,nX,dist,path = nodes.shift
    if nY == eY && nX == eX
      min_dist = dist
      break
    end
    (0..3).each do |dir|
      to_row = nY + [1,-1,0,0][dir]
      to_col = nX + [0,0,1,-1][dir]
      if valid(grid, visited, nY, nX, to_row, to_col)
        step = grid[to_row][to_col]
        visited[to_row][to_col] = 1
        nodes.push([to_row, to_col, dist+1, path.clone << step])
      end
    end
  end
  return min_dist, path if min_dist < Float::INFINITY
end

part1 = bfs(grid, sY, sX, eY, eX)
puts "Part 1: #{part1[0]} steps in path #{part1[1]}"
part2s = starts.collect do |s|
  bfs(grid, s[0], s[1], eY, eX)
end
part2 = part2s.compact.min_by{|p|p[0]}
puts "Part 2: #{part2[0]} steps in path #{part2[1]}"

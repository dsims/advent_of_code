filename = ARGV[0] || "input/day22.txt"
map = []
moves = ""
facing = 0
found_end = false
File.readlines(filename, chomp: true).each_with_index do |line, i|
  moves = line if found_end
  found_end = true if line == ""
  map << line if !found_end
end
max = map.max{|a,b| a.size <=> b.size}.size
map = map.map{|m|m.ljust(max, " ").chars}
#start = map.min{|a,b| a.index(".") <=> b.index(".") }
start = map.first
moves = moves.split(/([R,L])/).map{|m|"RL".include?(m) ? m : m.to_i}

pp map.collect(&:join)
pos = [map.index(start), start.index(".")] # row, col

def next_pos(map, pos, facing)
  case facing
  when 0
    row = pos[0]
    col = pos[1] + 1
    if col > map[pos[0]].size - 1 || map[row][col] == " "
      block = map[row].index("#")
      avail = map[row].index(".")
      return nil if avail.nil?
      if block.nil? || avail < block
        return [row, avail]
      else
        return nil
      end
    end
  when 2
    row = pos[0]
    col = pos[1] - 1 
    if col < 0 || map[row][col] == " "
      block = map[row].rindex("#")
      avail = map[row].rindex(".")
      return nil if avail.nil?
      if block.nil? || avail > block
        return [row, avail]
      else
        return nil
      end
    end
  when 1
    row = pos[0] + 1
    col = pos[1] 
    if row > map.size - 1 || map[row][col] == " "
      block = map.index{|r|r[col] == "#"}
      avail = map.index{|r|r[col] == "."}
      return nil if avail.nil?
      if block.nil? || avail < block
        return [avail, col]
      else
        return nil
      end
    end
  when 3
    row = pos[0] - 1
    col = pos[1] 
    if row < 0 || map[row][col] == " "
      block = map.rindex{|r|r[col] == "#"}
      avail = map.rindex{|r|r[col] == "."}
      return nil if avail.nil?
      if block.nil? || avail > block
        return [avail, col]
      else
        return nil
      end
    end
  end
  return [row, col] if map[row][col] != "#"
end

moves.each do |m|
  catch :blocked do
    if m.is_a? Integer
      m.times do
        result = next_pos(map, pos.dup, facing)
        if result.nil?
          throw :blocked
        else
          pos = result
          #map[pos[0]][pos[1]] = facing
        end
      end
    else
      facing += 1 if m == "R"
      facing -= 1 if m == "L"
      facing = 0 if facing == 4
      facing = 3 if facing == -1
    end
  end
end
pp map.collect(&:join)
pp pos
puts (1000 * (pos[0]+1)) + (4 * (pos[1]+1)) + facing

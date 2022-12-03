filename = ARGV[0] || "input/test02.txt"
PLAYER1 = ["A","B","C"] #rock, paper, scissors
PLAYER2 = ["X","Y","Z"] #rock, paper, scissors
DESIRED_RESULTS = ["X","Y","Z"] #lose, tie, win
# shift P2 so matching index position is losing (rock to scissors): ABC ZXY
p2_shapes_shifted = PLAYER2[..1].prepend PLAYER2.last 
shapes = []
# zipper-merge: AZBXCY
PLAYER1.each_with_index do |m,idx|
  shapes.concat [PLAYER1[idx], p2_shapes_shifted[idx]]
end
# extend so can always look forward: AZBXCYAZBXCY
shapes = shapes.concat shapes

def p2_battle_result(shapes, p1_shape, p2_shape)
  p1_idx = shapes.index(p1_shape)
  p2_idx = shapes[p1_idx..].index(p2_shape) + p1_idx #only look forward
  # distance between shapes in array can be 1, 3, or 5
  ((p2_idx - p1_idx - 1) / 2) #p2 0:lose, 1: tie, 2: win
end

part1 = File.readlines(filename, chomp: true).collect do |line|
  p1_shape, p2_shape = line.split(' ')
  p2_result = p2_battle_result(shapes, p1_shape, p2_shape)
  p2_shape_points = PLAYER2.index(p2_shape) + 1
  p2_shape_points + (p2_result * 3)
end.sum

part2 = File.readlines(filename, chomp: true).collect do |line|
  p1_shape, p2_result = line.split(' ')
  p2_result_idx = DESIRED_RESULTS.index(p2_result) #0,1,2
  possible_results = PLAYER2.collect do |p2_shape|
    p2_battle_result(shapes, p1_shape, p2_shape)
  end
  p2_shape = PLAYER2[possible_results.index(p2_result_idx)]
  p2_shape_points = PLAYER2.index(p2_shape) + 1
  p2_shape_points + (p2_result_idx * 3)
end.sum

puts "P2 score: part1: #{part1} part2: #{part2}"

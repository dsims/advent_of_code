filename = ARGV[0] || "input/test15.txt"
def manhattan_distance(x1, y1, x2, y2)
  (x2 - x1).abs + (y2 - y1).abs
end
sensors = []
becons = {}
minX = minY = 0
maxX = maxY = maxD = 0
File.readlines(filename, chomp: true).each_with_index do |line, i|
  sX, bX = line.scan(/x=([-]?\d+)/).flatten.map(&:to_i)
  sY, bY = line.scan(/y=([-]?\d+)/).flatten.map(&:to_i)
  d = manhattan_distance(sX, sY, bX, bY)
  sensors << {x: sX, y:sY, d: d}
  becons[bX] = bY
  minX = [minX, sX, bX].min
  maxX = [maxX, sX, bX].max
  maxY = [maxX, sX, bX].max
  maxD = [maxD, d].max
end

#Part1 (~4min): check every point on the row if it's close enough to a sensor
minX -= maxD
minY -= maxD
maxX += maxD
maxY += maxD
define_method :check_row do |row|
  matching_x = []
  (minX..maxX).each do |x|
    if sensors.any?{|s| manhattan_distance(s[:x], s[:y], x, row) <= s[:d] }
      matching_x << x if !(becons[x] && becons[x] == row)
    end
  end
  matching_x
end
part1 = check_row 10 #2000000
puts "Part1: #{part1.size}"

# Part2 (~30sec): The only open spot must be next to an intersection.
# So find all the inersections of all the sensor border lines
# Then check all the spots next to those intersections
minX = minY = 0
maxX = maxY = 20 #4000000
sensor_lines = []
sensors.each_with_index do |s, i|
  #x, y, and m (slope)
  lines = []
  lines << [s[:x], s[:y] + s[:d], -1]
  lines << [s[:x], s[:y] + s[:d], 1]
  lines << [s[:x], s[:y] - s[:d], 1]
  lines << [s[:x], s[:y] - s[:d], -1]
  sensor_lines << lines
end
intersections = []
sensor_lines.each do |s1|
  sensor_lines.each do |s2|
    next if s1 == s2
    s1.each do |line1|
      x1,y1,m1 = line1
      s2.each do |line2|
        x2,y2,m2 = line2
        next if m2 - m1 == 0
        # Equations of a Line (point slope form) to solve for x, then y
        iX = ((m2 * x2 - m1 * x1) - (y2 - y1)) / (m2 - m1)
        iY = m1 * (iX - x1) + y1
        intersections << [iX, iY]
      end
    end
  end
end
intersections.uniq!
intersections.each do |p|
  pX,pY = p
  (pX-1..pX+1).each do |x|
    next if x < minX || x > maxX
    (pY-1..pY+1).each do |y|
      next if y < minY || y > maxY
      if !sensors.any?{|s| manhattan_distance(s[:x], s[:y], x, y) <= s[:d]}
        return puts "Part2: Becon found at [#{x}, #{y}] with frequency #{(4000000 * x) + y}."
      end
    end
  end
end
puts "NOT FOUND?"

# method to print out a map of everything
define_method :print_test do
  (minY..maxY).each do |y|
    matching_x = check_row y
    (minX..maxX).each do |x|
      if becons[x] && becons[x] == y
        print "B"
      elsif sensors.find{|s|s[:x] == x && s[:y] == y}
        print "S"
      #elsif e = intersections.find{|e|e[0] == x && e[1] == y}
      #  print "E"
      elsif matching_x.include?(x)
        print "#"
      else
        print "."
      end
    end
    print "\n"
  end
end
#print_test
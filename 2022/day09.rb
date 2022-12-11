filename = ARGV[0] || "input/test09_2.txt"
class Rope
  attr_accessor :knots
  def initialize(num_knots)
    @knots = Array.new(num_knots){ Knot.new }
  end
  def move dir
    head = nil
    knots.each_with_index do |knot, idx|
      unless head
        case dir
          when 'U' then knot.y += 1
          when 'D' then knot.y -= 1
          when 'L' then knot.x -= 1
          when 'R' then knot.x += 1
        end
      else
        knot.move(head.x, head.y)
      end
      head = knot
    end
  end
  class Knot
    attr_accessor :x, :y, :positions
    def initialize() 
      @x = @y = 0
      @positions = []
    end
    def move hX, hY
      @y += ((hY - @y) <=> 0) if (hX - @x).abs > 1 && (hY - @y).abs > 0
      @x += ((hX - @x) <=> 0) if (hY - @y).abs > 1 && (hX - @x).abs > 0
      @x += ((hX - @x) <=> 0) if (hX - @x).abs > 1
      @y += ((hY - @y) <=> 0) if (hY - @y).abs > 1
      @positions.push [@x,@y]
    end
  end
end

rope1 = Rope.new(2)
rope2 = Rope.new(10)
File.readlines(filename, chomp: true).each_with_index do |line, i|
  dir, steps = line.split(' ')
  steps.to_i.times do
    rope1.move dir
    rope2.move dir
  end
end
part1, part2 = [rope1, rope2].map{ |rope| rope.knots.last.positions.uniq.size }
puts "Part1: #{part1} Part2: #{part2}"

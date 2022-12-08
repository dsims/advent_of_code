filename = ARGV[0] || "input/test07.txt"
filesystem = {"/" => {size: 0}}
cur_dir = []

File.readlines(filename, chomp: true).each_with_index do |line, i|
  inputs = line.split(' ')
  case inputs.first
  when '$'
    if inputs[1] == 'cd'
      if inputs.last == '..' then cur_dir.pop else cur_dir.push(inputs.last) end
    end
  when 'dir'
    unless filesystem.dig(*cur_dir + [inputs.last])
      cur_dir.inject(filesystem, :fetch)[inputs.last] = {size: 0}
    end
  else #file
    size, name = inputs
    cur_dir.inject(filesystem, :fetch)[name] = size.to_i
    cur_dir.each_with_index do |dir,i|
      cur_dir.take(i+1).inject(filesystem, :fetch)[:size] += size.to_i
    end
  end
end

dir_sizes = []
define_method(:collect_sizes) do |dir|
  dir.each do |k,v|
    if v.is_a?(Hash)
      dir_sizes.push(v[:size]) if k != "/"
      collect_sizes v
    end
  end
end
collect_sizes filesystem

part1 = dir_sizes.select{|s| s <= 100000}.sum
needed = 30000000 - (70000000 - filesystem['/'][:size])
part2 = dir_sizes.sort.find{|s| s >= needed}
print "Part1: #{part1} Part2: #{part2}"
#pp filesystem

require 'pry'

class MazeSolver
  attr_reader :maze
  attr_accessor :traveled_path, :visited_nodes, :node_queue, :solution_path, :display_solution_path

  def initialize(maze_string)
    @maze = maze_string
    @traveled_path = []
    @visited_nodes = []
    @node_queue = []
    @solution_path = []
  end

  def maze_array
    return @maze.split(/\n/).collect{|row| row.strip.split('')}
  end

  def solve
    self.add_start
    until self.node_queue.empty?
      current_node = self.node_queue.shift
      self.explore_neighbors(current_node)
    end
  end

  def add_start
    start_coords = self.find_start
    self.add_to_queues(start_coords, start_coords)
  end

  def find_start
    maze_array.detect.with_index do |row, index|
      row.detect.with_index do |col, i|
        return [i, index] if maze_array[index][i] == '→'
      end
    end
  end

  def add_to_queues(coord_pair, parent_coords)
    self.node_queue << coord_pair
    self.visited_nodes << coord_pair
    self.traveled_path << [coord_pair, parent_coords]
  end

  def explore_neighbors(parent_node)
    neighbors = self.get_adjacents(parent_node)
    neighbors.each do |neighbor|
      if self.has_legit?(neighbor)
        self.add_to_queues(neighbor, parent_node)
        if maze_array[neighbor.last][neighbor.first] == '@'
          self.solution_path << neighbor
          self.trace_crumbs(neighbor)
        end
      end
    end
  end

  def trace_crumbs(destination)
    self.traveled_path.reverse.each do |coord_set|
      to, from = coord_set
      self.solution_path << from if self.solution_path.last == to && self.solution_path.last != from
    end
  end

  def get_adjacents(center)
    x,y = center
    left = [x-1, y] if x > 0
    right = [x+1, y] if x < maze_array[y].size - 1
    up = [x, y-1] if y > 0
    down = [x, y+1] if y < maze_array.size - 1
    return [left,right,up,down].compact
  end

  def has_legit?(adjacent_node)
    x,y = adjacent_node
    maze_array[y][x] != '#' && !self.visited_nodes.include?(adjacent_node) 
  end

  def display_solution_path
    solved_maze = self.maze_array.dup
    self.solution_path.each do |coord_pair|
      x,y = coord_pair
      solved_maze[y][x] = '.' unless coord_pair == self.solution_path.first || coord_pair == self.solution_path.last
    end
    puts solved_maze.collect {|row| row.join('')}.join("\n")
  end

end

__END__
bfs(start, looking_for)
  create arrays (node_queue, visited_nodes, and traveled_path)
  add the start to the arrays
  while the queue is not empty
    take out the first element in the queue
    for each of the neighbors of this first element 
      if its not in the visited set and not blocked
        add this to the arrays
        if this contains what we are looking for
          return the backtrack of this node
        end if
      end if
    end for
  end while
end method
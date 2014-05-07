class NQueensProblem

  attr_reader :board_size, :queens

  def initialize(board_size)
    @board_size = board_size
    @queens = []
  end

  # A bitmask that allows for quickly deciding if another queen threatens this queen
  def threat_mask(x, y)
    (1 << (x - y + (board_size * 5))) +  # / diagonal (one of N * 2 - 1 possibilities)
    (1 << (x + y + (board_size * 2))) +  # \ diagonal (one of N * 2 - 1 possibilities)
    (1 << (x + board_size)) +            # horizontal (one of N possibilities)
    (1 << y)                             # vertical   (one of N possibilities) 
  end

  # All of the threat bitmasks for the given row
  def rows
    @rows ||= board_size.times.map do |x|
      board_size.times.map do |y|
        threat_mask(x, y)
      end
    end
  end

  def available_positions_on_next_row
    (rows[queens.size] || []).reject do |p|
      queens.any? do |q|
        q & p > 0
      end
    end
  end

  def solve(&block)
    available_positions_on_next_row.each do |q|
      queens << q
      if solution?
        yield self
      else
        solve(&block)
      end
      queens.pop
    end
    nil
  end

  def solution?
    queens.size == board_size
  end

  def self.number_solutions(board_size)
    cnt = 0
    NQueensProblem.new(board_size).solve { |qp| cnt += 1 }
    cnt
  end

  def to_s
    queens.map(&:to_s).join(' ')
  end

end

(1..12).each do |bs|
  start = Time.now.to_f
  n = NQueensProblem.number_solutions(bs)
  puts "#{bs}: #{n} [#{Time.now.to_f - start}]"
end

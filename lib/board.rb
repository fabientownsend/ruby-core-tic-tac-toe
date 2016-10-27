require 'marks'

class Board
  attr_reader :board
  attr_reader :POSITION_MIN
  attr_reader :POSITION_MAX

  def initialize(board_size = 3)
    @board = create_board(board_size)
    @POSITION_MIN = 0
    @POSITION_MAX = board.size ** 2
  end

  def set_mark(mark, position)
    position = Integer(position)
    in_range(position)
    available(position)

    board[get_row(position)][get_column(position)] = mark
  end

  def remove_mark(position)
    board[get_row(position)][get_column(position)] = position
  end

  def win?(mark)
    posibilities = rows + columns + diagonals
    posibilities.any? { |posibility| posibility.all? { |cell_mark| cell_mark  == mark } }
  end

  def tie?
    @board.flatten.none? { |mark| mark.is_a?(Integer) } && !win?(Mark::CROSS) && !win?(Mark::ROUND)
  end

  def free_positions
    flat_board = board.flatten
    flat_board.each_index.select { |index| empty?(flat_board[index]) }
  end

  def content
    board_string = ""

    board.flatten.each.with_index do |value, index|
      if !value.is_a?(Integer)
        board_string << value
      else
        board_string << " "
      end

      index += 1
      if  board_edge?(index) && index != @POSITION_MAX
        board_string << ","
      end

    end

    board_string
  end

  private

  def rows
    board
  end

  def columns
    board.transpose
  end

  def diagonals
    [first_diagonal, second_diagonal]
  end

  def first_diagonal
    diagonal = Array.new
    board.size.times { |index| diagonal << board[index][index] }
    diagonal
  end

  def second_diagonal
    second_diagonal = Array.new
    board.size.times { |index| second_diagonal << board[index][backward_index(index)] }
    second_diagonal
  end

  def empty?(spot)
    spot != Mark::ROUND && spot != Mark::CROSS
  end

  def create_board(board_size)
    id = 0

    new_board = Array.new
    board_size.times do
      new_row = Array.new
      board_size.times do
        new_row.push(id)
        id += 1
      end
      new_board.push(new_row)
    end
    new_board
  end

  def get_column(position)
    position % board.size
  end

  def get_row(position)
    position / board.size
  end

  def backward_index(index)
    board.size - index - 1
  end

  def in_range(position)
    if position < @POSITION_MIN || position > @POSITION_MAX
      raise OutOfRangeError
    end
  end

  def available(position)
    if !free_positions.include?(position)
      raise OccupiedPositionError
    end
  end

  def board_edge?(index)
    index % board.size == 0
  end
end

class OutOfRangeError < Exception
end

class OccupiedPositionError < Exception
end

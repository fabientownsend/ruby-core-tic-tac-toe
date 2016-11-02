require 'spec_helper'
require 'board_helper'
require 'board'
require 'marks'

RSpec.describe Board do
  let(:board) { Board.new }
  let(:board_helper) { BoardHelper.new(board) }

  it "is a free spot when the spot isn't used" do
    position = 0
    board_helper.string_to_board("   ,   ,   ")

    expect(board.free_positions.include?(position)).to be true
    expect(board_helper.board_to_string).to eq("   ,   ,   ")
  end

  it "isn't a free position when the spot is used" do
    position = 0
    board_helper.string_to_board("X  ,   ,   ")

    expect(board.free_positions.include?(position)).to be false
    expect(board_helper.board_to_string).to eq("X  ,   ,   ")
  end

  it "is a win with the first column" do
    board_helper.string_to_board("XO ,XO ,X  ")

    expect(board.win?(Mark::CROSS)).to be true
  end

  it "is a win with the second column" do
    board_helper.string_to_board(" XO, XO, X ")

    expect(board.win?(Mark::CROSS)).to be true
  end

  it "is a win with the third column" do
    board_helper.string_to_board(" OX, OX,  X")

    expect(board.win?(Mark::CROSS)).to be true
  end

  it "is a win with the first line" do
    board_helper.string_to_board("XXX, OO,   ")

    expect(board.win?(Mark::CROSS)).to be true
  end

  it "is a win with the second line" do
    board_helper.string_to_board("   ,XXX,OO ")

    expect(board.win?(Mark::CROSS)).to be true
  end

  it "is a win with the third line" do
    board_helper.string_to_board("   ,O  ,XXX")

    expect(board.win?(Mark::CROSS)).to be true
  end

  it "is a win with the forward diagonal" do
    board_helper.string_to_board("XO ,OX ,  X")

    expect(board.win?(Mark::CROSS)).to be true
  end

  it "is a win with the backward diagonal" do
    board_helper.string_to_board(" OX,OX ,X  ")

    expect(board.win?(Mark::CROSS)).to be true
  end

  it "shoud be a tie" do
    board_helper.string_to_board("XOX,XOX,OXO")

    expect(board.tie?).to be true
  end

  it "shoud not be a tie when it's a win" do
    board_helper.string_to_board("XXX,XXX,XXX")

    expect(board.tie?).to be false
  end

  it "create a board 3x3" do
    board = Board.new(3)
    expect(board.content).to eq([[0, 1, 2], [3, 4, 5], [6, 7, 8]])
  end

  it "create a board 4x4" do
    board = Board.new(4)
    expect(board.content).to eq([[0, 1, 2, 3], [4, 5, 6, 7],
                                 [8, 9, 10, 11], [12, 13, 14, 15]])
  end

  it "raise an error when it's not a int" do
    expect { board.set_mark(Mark::CROSS, "a string") }.to raise_error(ArgumentError)
  end

  it "raise an error when the spot is occupied" do
    position = 0
    board.set_mark(Mark::CROSS, position)
    expect { board.set_mark(Mark::CROSS, position) }.to raise_error(OccupiedPositionError)
  end

  it "raise an error when the position is too low" do
    expect { board.set_mark(Mark::CROSS, board.POSITION_MIN - 1) }.to raise_error(OutOfRangeError)
  end

  it "raise an error when the position is too hight" do
    expect { board.set_mark(Mark::CROSS, board.POSITION_MAX + 1) }.to raise_error(OutOfRangeError)
  end
end

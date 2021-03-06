require 'board'
require 'game'
require 'marks'

class FakePlayer
  attr_accessor :next_move
  attr_reader :mark
  attr_reader :ready

  def initialize(mark, ready)
    @mark = mark
    @ready = ready
  end
end

RSpec.describe Game do
  let (:board) { Board.new }
  let(:fake_player) { FakePlayer.new(Mark::CROSS, true) }
  let(:fake_player_2) { FakePlayer.new(Mark::ROUND, false) }
  let (:game) { Game.new(
    :board => board,
    :player_one => fake_player,
    :player_two => fake_player_2) }
  let(:board_helper) { BoardHelper.new(board) }

  it "return the current player" do
    expect(game.current_player.mark).to eq(Mark::CROSS)
  end

  it "return the current player after the first player played" do
    fake_player.next_move = 0
    game.play
    expect(game.current_player.mark).to eq(Mark::ROUND)
    expect(board_helper.board_to_string).to eq("X  ,   ,   ")
  end

  it "work with an Integer as char" do
    fake_player.next_move = "0"
    game.play
    expect(game.current_player.mark).to eq(Mark::ROUND)
    expect(board_helper.board_to_string).to eq("X  ,   ,   ")
  end

  it "return the game status" do
    expect(game.over?).to be false
  end

  it "return game status game over when it's a tie" do
    board_helper.string_to_board("XOX,XOX,OXO")
    expect(game.over?).to be true
  end

  it "return game status game over when it's a win" do
    board_helper.string_to_board("XO ,XO ,X  ")
    expect(game.over?).to be true
  end

  it "doesn't have a winner when it's a tie" do
    board_helper.string_to_board("XOX,XOX,OXO")
    expect(game.winner.empty?).to be true
  end

  it "return the winner when a player won" do
    board_helper.string_to_board("XO ,XO ,X  ")
    expect(game.winner.empty?).to be false
    expect(game.winner).to eq(Mark::CROSS)
  end

  private

  def execute_moves(moves)
    moves.each do |move|
      fake_player.next_move = move
      fake_player_2.next_move = move
      game.play
    end
  end
end

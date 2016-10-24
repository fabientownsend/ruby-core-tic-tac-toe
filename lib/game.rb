class Game
  attr_reader :current_player
  attr_reader :winner

  def initialize(board, player_one, player_two)
    @board = board
    @players = [player_one, player_two]
    @current_player = @players.first
    @winner = ""
  end

  def play
    move = @current_player.next_move

    if (is_valid?(move) && !over?)

      @board.set_mark(@current_player.mark, Integer(move))

      if (!over?)
        switch_players
      end
    end
  end

  def over?
    @board.win?(@current_player.mark) || @board.tie?
  end

  def winner
    if (!@board.tie?)
      @winner = @current_player.mark
    else
      @winner
    end
  end

  private

  def is_valid?(position)
    is_integer(position) && board_range?(Integer(position)) && available?(Integer(position))
  end

  def available?(position)
    @board.free_positions.include?(position)
  end

  def is_integer(value)
    begin
      Integer(value)
    rescue
      return false
    end
  end

  def board_range?(position)
    position >= @board.POSITION_MIN && position <= @board.POSITION_MAX
  end

  def switch_players
    @current_player = @players.reverse!.first
  end
end

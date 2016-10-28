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
    if (!over?)
      @board.set_mark(@current_player.mark, @current_player.next_move)
    end

    if (!over?)
      switch_players
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

  def switch_players
    @current_player = @players.reverse!.first
  end
end

class Game
  attr_reader :current_player
  attr_reader :winner

  def initialize(args)
    @board = args[:board]
    @players = [args[:player_one], args[:player_two]]
    @current_player = @players.first
    @winner = ""
  end

  def play
    if (!over? && @current_player.ready)
      @board.set_mark(@current_player.mark, @current_player.next_move)

      if (!over?)
        switch_players
        play
      end
    else
      return
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

require_relative 'player'

class  ComputerPlayer < Player
  def pieces
    @board.find{ |piece| piece.color == @color}
  end

  def set_error(message)
    puts message
  end

  def turn
    @choices = []
    until @choices.count == 2
      piece = pieces.sample
      next if piece.valid_moves.empty?
      @choices << piece.pos
      @choices << piece.moves.sample
    end

    @choices
  end
end

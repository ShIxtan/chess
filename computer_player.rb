require_relative 'player'

class  ComputerPlayer < Player
  WEIGHTS = {King => 200, Queen => 9, Rook => 5, Bishop => 3, Knight => 3, Pawn => 1}

  def set_error(message)
    puts message
  end

  def turn()
    best_move = best_score = nil

    @board.moves(@color).each do |move|
      test_board = @board.simulate(move)
      # return move if test_board.checkmate?(enemy_color)
      test_score = -1 * negamax(test_board, toggle_color(@color), 1)

      if best_score.nil? || test_score > best_score
        best_move, best_score = move, test_score
      end
    end

    best_move
  end

  def negamax(test_board, color, depth)
    return score(test_board) * (color == @color ? 1 : -1) if depth == 0
    max = -250
    best_move = nil
    test_board.moves(color).each do |move|
      test_score = -1 * negamax(test_board.simulate(move), toggle_color(color), depth - 1)
      max = test_score if test_score > max
    end
    max
  end


  def score(board)
    colors = Hash.new(0)

    board.pieces.each do |piece|
      colors[piece.color] += WEIGHTS[piece.class]
      colors[piece.color] += 0.1 * piece.moves.count
    end

    colors[@color] - colors[enemy_color]
  end

  # def best_enemy_move(test_board)
  #   ComputerPlayer.new("bot#{rand(100)}", test_board, enemy_color).turn(true)
  # end

end

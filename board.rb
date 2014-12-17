require_relative 'pieces'

class InvalidMoveError < StandardError
end

class Board
  def initialize
    @grid = Array.new(8) {Array.new(8)}
    setup_board
  end

  def setup_board
    order = {red: [0, 1], blue: [7, 6]}.each do |color, row|
      setup_row(row[0], color)
      setup_pawns(row[1], color)
    end
  end

  def setup_row(row, color)
    order = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]

    order.each_with_index do |piece, i|
      self[[row, i]] = piece.new([row, i], color, self)
    end
  end

  def setup_pawns(row, color)
    8.times do |i|
      self[[row, i]] = Pawn.new([row, i], color, self)
    end
  end

  def in_check?(color)
    king = find { |tile| tile.class == King && tile.color == color }.first
    opposite = (color == :red ? :blue : :red)

    enemies = find {|tile| tile.color == opposite}
    enemies.any? { |enemy| enemy.moves.include?(king.pos)}
  end

  def checkmate?(color)
    return false unless in_check?(color)
    # accomodate stalemate
    pieces = find { |piece| piece.color == color }
    pieces.each do |piece|
      piece.moves.each do |to|
        unless simulate([piece.pos, to]).in_check?(color)
          return false
        end
      end
    end

    true
  end

  def find(&proc)
    pieces.select do |piece|
      proc.call(piece)
    end
  end

  def pieces
    @grid.flatten.compact
  end

  def move(color, moves)
    from, to = moves
    raise InvalidMoveError.new("No piece there") if self[from].nil?
    raise InvalidMoveError.new("That is not your piece") if self[from].color != color
    unless self[from].moves.include?(to)
      raise InvalidMoveError.new("#{self[from].class} can't move there")
    end

    # make following error more informative
    if simulate([from, to]).in_check?(color)
      raise InvalidMoveError.new("You are in check")
    end

    perform_move(from, to)
  end

  def simulate(poses)
    from, to = poses
    self.dup.perform_move(from, to)
  end

  def dup
    dup_board = self.class.new
    @grid.each_with_index do |row, x|
      row.each_index do |y|
        dup_board[[x, y]] = (self[[x, y]].nil? ? nil : self[[x, y]].dup(dup_board))
      end
    end

    dup_board
  end

  def [](pos)
    x, y = pos
    @grid[x][y]
  end

  def []=(pos, value)
    x, y = pos
    @grid[x][y] = value
  end

  protected

  def perform_move(from, to)
    self[[to[0], to[1]]], self[[from[0], from[1]]] = self[from], nil
    self[to].move(to)
    self
  end
end

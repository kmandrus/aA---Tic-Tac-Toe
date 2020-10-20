require_relative 'tic_tac_toe'

class TicTacToeNode
  attr_reader :board, :next_mover_mark, :prev_move_pos, :children

  def initialize(board, next_mover_mark, prev_move_pos = nil)
    @board = board
    @next_mover_mark = next_mover_mark
    @prev_move_pos = prev_move_pos
    @children
  end

  def losing_node?(evaluator)
    if board.over?
      return false if @board.tied? || (evaluator == board.winner)
      return true
    end

    if evaluator == next_mover_mark #it's the evaluator's turn
      return true if children.all? { |child| child.losing_node?(evaluator) }
    else #it's the opponents turn
      return true if children.any? { |child| child.losing_node?(evaluator) }
    end 
    false
  end

  def winning_node?(evaluator) 
    return (evaluator == board.winner) if board.over?
      
    if evaluator == next_mover_mark #it's the evaluator's turn
      return true if children.any? { |child| child.winning_node?(evaluator) }
    else #it's the opponent's turn
      return true if children.all? { |child| child.winning_node?(evaluator) }
    end
    false
  end

  # This method generates an array of all moves that can be made after
  # the current move.
  def children
    return @children if @children
    @children = []
    @board.each_with_pos do |square, pos|
      add_child(pos) if @board.empty?(pos)
    end
    @children
  end

  private

  def add_child(move_pos)
    child_board = @board.dup
    child_board[move_pos] = next_mover_mark
    child_next_mover_mark = ((next_mover_mark == :x) ? :o : :x)
    @children << TicTacToeNode.new(child_board, child_next_mover_mark, move_pos)
  end
  
end

class Conditional
  LOGIC_OPERATORS = ['==', '!=', '>', '>=', '<', '<='].freeze
  LOGIC_VALUES = ['true', 'false', /\d+/].freeze
  attr_accessor :type, :logic, :value

  class OperatorError < StandardError; end
  class InvalidValueError < StandardError; end

  def initialize(type:, logic:, value:)
    @type = type
    @logic = logic
    @value = value
  end

  def valid_format!
    raise OperatorError, 'Invalid operator' unless logic.start_with?(*LOGIC_OPERATORS)

    match_logic_value = LOGIC_VALUES.any? { |logic_value| logic.match?(logic_value) }
    raise InvalidValueError, 'Invalid value' unless match_logic_value
  end

  def valid?(gamestate)
    valid_format!
    evaluate(gamestate)
    # fix
    true
  end

  def evaluate(_gamestate)
    logic_operator, logic_value = logic.split
    logic_value = logic_value.match?(/\d+/) ? logic_value.to_i : logic_value.downcase
    # gamestate.valid_move?(logic_operator, logic_value)
  end
end

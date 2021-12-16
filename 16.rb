INPUT = File.read("./16.txt").strip

class PacketParser
  attr_reader :str, :position

  def initialize(str)
    @str = [str].pack("H*").unpack("B*").first
    @position = 0
  end

  Literal = Struct.new(:version, :type_id, :value) do
    def version_number_sum
      version
    end
  end

  Operator = Struct.new(:version, :type_id, :length_type_id, :subpackets) do
    def version_number_sum
      version + subpackets.sum(&:version_number_sum)
    end
  end

  class Sum < Operator
    def value
      subpackets.sum(&:value)
    end
  end

  class Product < Operator
    def value
      subpackets.map(&:value).reduce(:*)
    end
  end

  class Minimum < Operator
    def value
      subpackets.map(&:value).min
    end
  end

  class Maximum < Operator
    def value
      subpackets.map(&:value).max
    end
  end

  class Greater < Operator
    def value
      subpackets[0].value > subpackets[1].value ? 1 : 0
    end
  end

  class Less < Operator
    def value
      subpackets[0].value < subpackets[1].value ? 1 : 0
    end
  end

  class Equal < Operator
    def value
      subpackets[0].value == subpackets[1].value ? 1 : 0
    end
  end

  TYPE_LITERAL = 4
  TYPE_SUM = 0
  TYPE_PRODUCT = 1
  TYPE_MINIMUM = 2
  TYPE_MAXIMUM = 3
  TYPE_GREATER = 5
  TYPE_LESS = 6
  TYPE_EQUAL = 7

  OPERATOR_TOTAL_LENGTH_TYPE = 0
  OPERATOR_SUBPACKET_COUNT_TYPE = 1

  OPERATOR_CLASSES = {
    TYPE_SUM => Sum,
    TYPE_PRODUCT => Product,
    TYPE_MINIMUM => Minimum,
    TYPE_MAXIMUM => Maximum,
    TYPE_GREATER => Greater,
    TYPE_LESS => Less,
    TYPE_EQUAL => Equal
  }

  def parse_packet
    version = parse_version
    type_id = parse_type_id

    case type_id
    when TYPE_LITERAL
      value = parse_literal_value
      Literal.new(version, type_id, value)
    else
      length_type_id, subpackets = parse_operator_subpackets
      OPERATOR_CLASSES.fetch(type_id).new(version, type_id, length_type_id, subpackets)
    end
  end

  def parse_version
    parse_n_bit_value(3)
  end

  def parse_type_id
    parse_n_bit_value(3)
  end

  def parse_literal_value
    lieral_ended = false
    value = ""

    loop do
      literal_ended = true if str[position] == "0"
      advance
      value << str[(position)..(position + 3)]
      advance(4)
      break if literal_ended
    end

    value.to_i(2)
  end

  def parse_operator_subpackets
    length_type_id = parse_n_bit_value(1)
    subpackets = case length_type_id
    when OPERATOR_TOTAL_LENGTH_TYPE
      parse_total_length_type_operator_subpackets
    when OPERATOR_SUBPACKET_COUNT_TYPE
      parse_subpacket_count_type_operator_subpackets
    end

    [length_type_id, subpackets]
  end

  def parse_total_length_type_operator_subpackets
    total_length = parse_n_bit_value(15)
    original_position = position
    subpackets = []
    while position < (original_position + total_length)
      subpackets << parse_packet
    end

    subpackets
  end

  def parse_subpacket_count_type_operator_subpackets
    subpacket_count = parse_n_bit_value(11)
    subpacket_count.times.map { parse_packet }
  end

  private
  def parse_n_bit_value(n)
    value = str[(position)..(position + n - 1)].to_i(2)
    advance(n)
    value
  end

  def advance(n = 1)
    @position += n
  end
end

def part_1
  parser = PacketParser.new(INPUT)
  packet = parser.parse_packet
  puts "Part 1: #{packet.version_number_sum}"
end

def part_2
  parser = PacketParser.new(INPUT)
  packet = parser.parse_packet
  puts "Part 2: #{packet.value}"
end

part_1
part_2

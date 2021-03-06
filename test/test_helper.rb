$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'erlectricity'
require 'rubygems'
require 'test/unit'

def run_erl(code)
  cmd = %Q{erl -noshell -eval "A = #{code.split.join(' ')}, io:put_chars(A)." -s erlang halt}
  `#{cmd}`
end

def encode_packet(code)
  bin = run_erl("term_to_binary(#{code})")
  [bin.length, bin].pack("Na#{bin.length}")
end

def word_length
  (1.size * 8) - 2
end

class FakePort < Erlectricity::Port
  attr_reader :sent
  attr_reader :terms
  
  def initialize(*terms)
    @terms = terms
    @sent = []
    super(StringIO.new(""), StringIO.new(""))
  end

  def send(term)
    sent << term
  end
  
  private
  def read_from_input
    @terms.shift
  end
end

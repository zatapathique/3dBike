class Fixnum
  def to_byte
    [self].pack('C')
  end
  def to_sec
    self
  end
end

class SerialPort
  def read_last_byte
    readout = self.bytes.to_a.last
    self.rewind
    return readout
  end

  def write_byte(num)
    self.write num.to_byte
  end
end

class String
  def to_sec
    parts = self.split(':').reverse
    parts.each_with_index.inject(0){|sum, (l, i)| sum += l.to_f * 60**i }
  end
end
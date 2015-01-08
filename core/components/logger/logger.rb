module Logger
  def self.info(entry)
    entry.split("\n").each {|line| print("[INFO] \t#{line} \n") }
  end

  def self.error(entry)
    entry.split("\n").each {|line| print("[ERROR] \t#{line} \n") }
  end
end
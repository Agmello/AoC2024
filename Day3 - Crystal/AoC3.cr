#content = File.read("example.txt")
#content = File.read("example2.txt")
content = File.read("input.txt")

part1 = false;

class AoCMath
  @operation : String
  @term1 : Int32
  @term2 : Int32

  def initialize(@operation, @term1, @term2)
  end

  def result
    #puts "Multipling: #{@term1} and #{@term2}"
    @term1*@term2
  end
end

def handle(input)
  #puts "Handling #{input}"
  re = /(mul)\(([0-9]+),([0-9]+)\)/
  matches = [] of AoCMath
  input.scan(re) do |match|
        ##puts match
        #puts "\t#{match[2]}"
        matches << AoCMath.new(match[1], match[2].to_i, match[3].to_i)
      end

  result = 0
  matches.each do |match|
    result += match.result
  end

  result
end

if part1
  #puts "Part 1"
  value = handle(content)
else
#  #puts content
#  #content = content.delete &.in?('\n', '\r')
#  #puts content
#  #puts "Part 2"
#  value = 0
#  #Between do and dont
#  reg = /(do\(\))(.*)(don't\(\))/
#  count = 1
#  content.scan(reg) do |match|
#    puts "#{count}. #{match[0]}"
#    value += handle(match[2])
#    count += 1
#  end
#  #puts "From start"
#  # Start to first do or dont
#  #regStart =/(.*)(do\(\)|don't\(\))/
#  #regStart = /(.*)(do\(\)|don't\(\)).*$/
#  regStart = /^(.*?)(do\(\)|don't\(\))/
#  startMatch = content.scan(regStart)
#  ##puts startMatch[0][1]
#  handleStart = handle(startMatch[0][1])
#  ##puts "Start result #{handleStart[0][0]}"
#  value += handleStart
#  puts "#{count}. #{startMatch[0][0]}"
#  count += 1
#  # End
#  regEnd = /.*(do\(\)|don't\(\))(.*)$/
#  endMatch = content.scan(regEnd)
#  if(endMatch[0][1] == "do()")
#    handleEnd = handle(endMatch[0][2])
#    puts "#{count}. #{endMatch[0][0]}"
#    ##puts "End result #{handleEnd}"
#    value +=  handleEnd
#  end
  value = 0;
  count = 0;
  re =/(do\(\)|don't\(\)|(mul)\(([0-9]+),([0-9]+)\))/
  resString = ""
  content.scan(re) do |match|
        ##puts match
        #puts "\t#{match[2]}"
        resString += match[1]
      end
  #puts resString
  re = /(do\(\))(.*?)(don't\(\))/
  resString.scan(re) do |match|
    puts "#{count}. #{match[0]}"
    value += handle(match[2])
    count+=1
  end
  re = /.*(do\(\)|don't\(\))(.*)$/
  resString.scan(re) do |match|
    puts "#{count} END. #{match[1]} - #{match[2]}"
    if(match[1] == "do()")
      value += handle(match[2])
      count+=1
    end
  end
  if(!resString.starts_with?("do"))
    re = /(.*)(do\(\)|don't\(\)).*/
    resString.scan(re) do |match|
      puts "#{count} Start. #{match[1]}"
        value += handle(match[2])
        count+=1
    end
  end
end

puts "Result #{value}"

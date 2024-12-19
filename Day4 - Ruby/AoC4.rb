puts "My first program"
#content = File.read("example.txt")
content = File.read("input.txt")
class Letter
    def initialize(letter, west, north)
        @value = letter
        @west = west
        @north = north
        @used = false
    end
      # Basic setter method
    attr_accessor :value
    attr_accessor :west
    attr_accessor :north
    attr_accessor :east
    attr_accessor :south

    attr_accessor :used

    def nw
        return @north != nil ? @north.west : nil
    end
    def ne
        return @north != nil ? @north.east : nil
    end
    def sw
        return @south != nil ? @south.west : nil
    end
    def se
        return @south != nil ? @south.east : nil
    end

    def check_direction(dir,expected)
        if(expected == 'V')
            @used = true
            return true
        end
        l = nil
        case dir
        when 'W'
            l = @west 
        when 'E'
            l = @east
        when 'N'
            l = @north
        when 'S'
            l = @south
        when 'NW'
            l = nw()

        when 'SW'
            l = sw()
        when 'NE'
            l = ne()
        when 'SE'
            l = se()
        end
        retval = l == nil ? false : l.value == expected ? l.check_direction(dir,next_letter(expected)) : false
        if(retval == true)
            @used = true;
        end
        return retval
    end

    def next_letter(l)
        case l
        when 'X'
            return 'M'
        when 'M'
            return 'A'
        when 'A'
            return 'S'
        when 'S'
            return 'V'
        end
    end

    def is_x()
        if(@value != 'A')
            return false
        end
        if(north_eq("M") && south_eq("S"))
            return true
        end
        if(north_eq("S") && south_eq("M"))
            return true
        end
        if(west_eq("M") && east_eq("S"))
            return true
        end
        if(west_eq("S") && east_eq("M"))
            return true
        end
        return false
        
    end
    def north_eq(l)
        if(nw() == nil || ne() == nil)
            return false
        end
        return nw().value == l && ne().value == l
    end

    def south_eq(l)
        if(sw() == nil || se() == nil)
            return false
        end
        return sw().value == l && se().value == l
    end

    def west_eq(l)
        if(nw() == nil || sw() == nil)
            return false
        end
        return nw().value == l && sw().value == l
    end

    def east_eq(l)
        if(se() == nil || ne() == nil)
            return false
        end
        return se().value == l && ne().value == l
    end
end

str = ["abc","def","ghi"]

map = []
first = nil
xses = []
ases = []
content.split("\r\n").each do |row|
    last = nil
    rowValues = []
    row.chars.each do |char|
        north = last != nil ? last.north != nil ? last.north.east : nil : first;
        letter = Letter.new(char, last, north)
        rowValues << letter

        if(last != nil)
            last.east = letter
        end
        if(north != nil)
            north.south = letter
        end
        if(char == 'X')
            xses << letter
        end
        if(char == 'A')
            ases << letter
        end
        last = letter
    end
    first = rowValues[0]
    map << rowValues
end



count = 0
direction = ["N","W","S","E","NW","NE","SW","SE"]
xses.each do |x|
    direction.each do |dir|
        if(x.check_direction(dir, 'M'))
            count += 1
        end
    end
end
puts "Part 1 - #{count}"
#map.each do |row|
#    row.each do |l|
#        if(l.used == true)
#            print "#{l.value} "
#        else
#            print ". "
#        end
#        
#    end
#    puts ""
#end
count_part2 = 0
ases.each do |a|
    if(a.is_x())
        count_part2 += 1
    end
end
puts "Part 2 - #{count_part2}"

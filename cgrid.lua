return {
    new = function(self, side)
        if bit.band(side, side - 1) ~= 0 then
            return -- Error Not Power Of Two
        end
        
        local array = {}
        for index = 0, side*side - 1 do
            array[index] = 0
        end
        
        return {
            side = side,
            exp = math.log(side)/math.log(2),
            mask = side - 1,
            array = array,
            
            index = self.index,
            get = self.get,
            set = self.set
        }
        --[[ -- Example --
            side == 8; exp == 3; mask == 7
            array = {[0] = 
                0, 0, 0, 0, 0, 0, 0, 0,
                0, 0, 0, 0, 0, 0, 0, 0,
                0, 0, 0, 0, 0, 0, 0, 0,
                0, 0, 0, 0, 0, 0, 0, 0,
                0, 0, 0, 0, 0, 0, 0, 0,
                0, 0, 0, 0, 0, 0, 0, 0,
                0, 0, 0, 0, 0, 0, 0, 0,
                0, 0, 0, 0, 0, 0, 0, 0
            }
            
            (7 & mask) -->> 7
            (8 & mask) -->> 0
            (9 & mask) -->> 1
            (-1 & mask) -->> 7
            
            (3 << exp) == (3*side) == 24
            
        --]]
    end,
    index = function(self, x, y)
        x = bit.band(x, self.mask)
        y = bit.band(y, self.mask)
        return bit.lshift(y, self.exp) + x
    end,
    get = function(self, x, y)
        return self.array[ self:index(x, y) ]
    end,
    set = function(self, x, y, value)
        self.array[ self:index(x, y) ] = value
        return self
    end
}

local AND, OR, SHL, SHR; do
    local bit = require("bit")
    AND = bit.band
    OR = bit.bor
    SHL = bit.lshift
    SHR = bit.rshift
end

return {
    new = function(self, side, x, y)
        if AND(side, side - 1) ~= 0 then
            return print("Error: Not Power Of Two")
        end
        local array = {}
        for index = 0, side^2-1 do
            array[index] = 0
        end
        return {
            x = x or 0,
            y = y or 0,
            exp = math.log(side)/math.log(2),
            side = side,
            mask = side - 1,
            array = array,
            
            index = self.index,
            point = self.point,
            get = self.get,
            set = self.set,
            rawget = self.rawget,
            rawset = self.rawset,
            
            fill = self.fill,
            up = self.up,
            down = self.down,
            left = self.left,
            right = self.right
        }
        --[[ Example
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
        x = AND(x + self.x, self.mask)
        y = AND(y + self.y, self.mask)
        return OR(SHL(y, self.exp), x)
    end,
    point = function(self, index)
        local x = AND(index, self.mask)
        local y = SHR(index, self.exp)
        return AND(x - self.x, self.mask), AND(y - self.y, self.mask)
    end,
    get = function(self, x, y)
        return self.array[self:index(x, y)]
    end,
    set = function(self, x, y, value)
        self.array[self:index(x, y)] = value
        return self
    end,
    rawget = function(self, index)
        return self.array[index]
    end,
    rawset = function(self, index, value)
        self.array[index] = value
        return self
    end,
    
    
    fill = function(self, data)
        for y = self.y, self.y + self.mask do
            for x = self.x, self.x + self.mask do
                self:set(x - self.x, y - self.y, data:get(x, y))
            end
        end
    end,
    up = function(self, data)
        self.y = self.y - 1
        for x = 0, self.mask do
            self:set(x, 0, data:get(self.x + x, self.y))
        end
        return self
    end,
    down = function(self, data)
        self.y = self.y + 1
        for x = 0, self.mask do
            self:set(x, self.mask, data:get(self.x + x, self.y + self.mask))
        end
        return self
    end,
    left = function(self, data)
        self.x = self.x - 1
        for y = 0, self.mask do
            self:set(0, y, data:get(self.x, self.y + y))
        end
        return self
    end,
    right = function(self, data)
        self.x = self.x + 1
        for y = 0, self.mask do
            self:set(self.mask, y, data:get(self.x + self.mask, self.y + y))
        end
        return self
    end
}

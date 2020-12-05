local awful     = require("awful")
local grect = require("gears.geometry").rectangle

local visual_commands = {
  {
    description = "swap client by direction",
    pattern = {'%d*', '[HJKL]'},
    handler = function(_, count, movement)
      local directions = {H = 'left', J = 'down', K = 'up', L = 'right'}
      local sel        = client.focus
      local scr        = sel.screen
      count = count == '' and 1 or tonumber(count)

      -- this is a bit hacky, but awful.client.swap.bydirection doesn't work as expected
      if sel then
        local clients    = scr.clients
        local geometries = {}
        for i,cl in ipairs(clients) do
          geometries[i] = cl:geometry()
        end

        local current = sel
        for _ = 1, count do
          local target = grect.get_in_direction(directions[movement], geometries, current:geometry())

          -- If we found a client to swap with, then go for it
          if target then
            current = clients[target]
            current:swap(sel)
          else
            break
          end
        end
      end
    end
  },
  {
    description = "change client height factor",
    pattern = {'[jk]'},
    handler = function(_, movement)
      if movement == 'j' then
        awful.client.incwfact(-0.05)
      else
        awful.client.incwfact(0.05)
      end
    end
  },
  {
    description = "change master width factor",
    pattern = {'[hl]'},
    handler = function(_, movement)
      if movement == 'h' then
        awful.tag.incmwfact(-0.05)
      else
        awful.tag.incmwfact(0.05)
      end
    end
  },
  {
    description = "change number of master clients",
    pattern = {'m', '%d*', '[,.]'},
    handler = function(_, _, count, movement)
      count = count == '' and 1 or tonumber(count)

      if movement == '.' then
        awful.tag.incnmaster(count, nil, true)
      else
        awful.tag.incnmaster(-count, nil, true)

      end

    end
  },
  {
    description = "change number of columns",
    pattern = {'c', '%d*', '[,.]'},
    handler = function(_, _, count, movement)
      count = count == '' and 1 or tonumber(count)

      if  movement == '.' then
        awful.tag.incncol(count, nil, true)
      else
        awful.tag.incncol(-count, nil, true)
      end
    end
  },
  {
    description = "change layout",
    pattern = {'%d*', '[,.]'},
    handler = function(_, count, movement)
      count = count == '' and 1 or tonumber(count)

      if  movement == '.' then
        awful.layout.inc(count)
      else
        awful.layout.inc(-count)
      end
    end
  },
  {
    description = "change useless gap",
    pattern = {'g', '%d*', '[,.]'},
    handler = function(_, _, count, movement)
      count = count == '' and 1 or tonumber(count)

      if  movement == '.' then
        awful.tag.incgap(count)
      else
        awful.tag.incgap(-count)
      end
    end
  },
}

return visual_commands

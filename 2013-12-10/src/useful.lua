useful = {}

function useful.tri(cond, yes, no)
	if cond then
		return yes
	else
		return no
	end
end
function useful.shuffle(tab)
	local newtab = {}
	while #tab>0 do
		local i = math.random(1,#tab)
		table.insert(newtab, tab[i])
		table.remove(tab, i)
	end
	tab = newtab
	return newtab
end
function useful.sign( n )
	if n>=0 then
		return 1
	else
		return -1
	end
end

function useful.bresenham(x1, y1, x2, y2, plot)
  delta_x = x2 - x1
  ix = delta_x > 0 and 1 or -1
  delta_x = 2 * math.abs(delta_x)
 
  delta_y = y2 - y1
  iy = delta_y > 0 and 1 or -1
  delta_y = 2 * math.abs(delta_y)
 
  plot(x1, y1)
 
  if delta_x >= delta_y then
    error = delta_y - delta_x / 2
 
    while x1 ~= x2 do
      if (error >= 0) and ((error ~= 0) or (ix > 0)) then
        error = error - delta_x
        y1 = y1 + iy
      end
 
      error = error + delta_y
      x1 = x1 + ix
 
      plot(x1, y1)
    end
  else
    error = delta_x - delta_y / 2
 
    while y1 ~= y2 do
      if (error >= 0) and ((error ~= 0) or (iy > 0)) then
        error = error - delta_y
        x1 = x1 + ix
      end
 
      error = error + delta_x
      y1 = y1 + iy
 
      plot(x1, y1)
    end
  end
end

function useful.lerp(n, a, b)
	return (1-n)*a+n*b
end
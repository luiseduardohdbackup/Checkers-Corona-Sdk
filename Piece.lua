Ficha = {}

local squareLength = math.min( display.contentWidth, display.contentHeight )
print("squareLength: "..squareLength)
local insideSquareLength = squareLength / 8
print("insideSquareLength: "..insideSquareLength)
local fichaRadio = insideSquareLength / 2 * .8
print("fichaRadio: "..fichaRadio)
--local fichaRadio = 
local fichaSeleccionada = false


local fichas = {}
for i = 1, 8, 1 do
	fichas[i] = {}
	for j = 1, 8, 1 do
		fichas[j] = {}
	end
end

--local dragBody = function ( event, params )
local dragBody = function ( ficha, event , params )
	print("dragBody")
	--if fichaSeleccionada == false then
		--ficha = event.target
    imagen = ficha.image
		fichaSeleccionada = true
		phase = event.phase
    resaltado = ficha.resaltado or {}
		if ( phase == "began" ) then
			-- startX = ficha.x
			-- startY = ficha.y
    elseif ( phase == "moved" ) then  
      imagen.x = event.x
      imagen.y = event.y
      print("event.x: "..event.x)
      print("event.y: "..event.y)
      resaltado.x = event.x
      resaltado.y = event.y
      
    elseif ( phase == "ended" ) then
      if not ( movimientoSeleccionado == nil ) then
        ficha.square = nil
        imagen.x = movimientoSeleccionado.x
        imagen.y = movimientoSeleccionado.y
        
        resaltado.x = movimientoSeleccionado.x
        resaltado.y = movimientoSeleccionado.y

        column = ficha.column
        row = ficha.row
        fichas[column][row] = nil
        ficha.column  = movimientoSeleccionado.column
        ficha.row  = movimientoSeleccionado.row
        movimientoSeleccionado = nil
      else
        local xIni = display.contentCenterX -  ( insideSquareLength * 8 ) / 2 + insideSquareLength / 2
        local yIni = display.contentCenterY -  ( insideSquareLength * 8 ) / 2 + insideSquareLength / 2
        imagen.x = xIni + insideSquareLength * ( ficha.column - 1 )
        imagen.y = yIni + insideSquareLength * ( ficha.row - 1 )
        
      
        resaltado.x = imagen.x
        resaltado.y = imagen.y
        --ficha.x = startX
        --ficha.y = startY
        fichaSeleccionada = false
      end
    end
	--end
	-- Stop further propagation of touch event
	return true
end
    
 
function Ficha:new( tipo, column, row )
	local object = {}
  --object.image = image
	--object.class = Ficha
	object.radius = fichaRadio 
	object.name = "ficha"
	object.tipo = tipo
	object.column = column
	object.row = row
	fichas[column][row]= object
  --object.fichas = fichas
  image = display.newCircle( 0, 0, fichaRadio  )

	local xIni = display.contentCenterX -  ( insideSquareLength * 8 ) / 2 + insideSquareLength / 2
	local yIni = display.contentCenterY -  ( insideSquareLength * 8 ) / 2 + insideSquareLength / 2

	image.x = xIni + insideSquareLength * ( column - 1 )
	image.y = yIni + insideSquareLength * ( row - 1 )
  
	if tipo == "White" then
		image:setFillColor( 255, 255, 255 )
	elseif tipo == "Black" then
		image:setFillColor( 255, 0, 0 )
	else
		print("Error: Tipo incorrecto, las opciones son \"White\" y \"Black\"")
	end
	object.image = image
  --[[
  image:addEventListener( 
    "touch",
    function( event,params ) 
      print("touch")
      dragBody(object,event,params) 
    end
  )
  ]]--
	--setmetatable(object, { __index = Ficha })  -- Da problemas con Corona
  setmetatable(object, { __index = Ficha })
	return object
end

function Ficha:getAll()
	return fichas
end

function Ficha:canMove ( )
	print("canMove")
	local ficha = self
	--movimientos = {}
  fichas = ficha.getAll()
	--Arriba izquierda
	if	( not ( fichas [ ficha.column - 1 ] == nil ) ) 
		and 
		ficha.column - 1 > 0 and ficha.column - 1 <= 8 
		and 
		ficha.row - 1 > 0 and ficha.row - 1 <= 8 
		and
		fichas [ ficha.column - 1 ][ ficha.row - 1  ] == nil 
		then
		--table.insert(movimientos,{ ficha.row - 1 , ficha.column - 1 })
		return true
	end

	--Arriba derecha
	if ( not ( fichas [ ficha.column + 1 ] == nil ) ) 
		and 
		ficha.column + 1 > 0 and ficha.column + 1 <= 8 
		and 
		ficha.row - 1 > 0 and ficha.row - 1 <= 8 
		and
		fichas [ ficha.column + 1 ][ ficha.row - 1  ] == nil 
		then
		--table.insert(movimientos,{ ficha.row - 1 , ficha.column + 1 })
		return true
	end

	--Abajo izquierda
	if	( not ( fichas [ ficha.column - 1 ] == nil ) ) 
		and 
		ficha.column - 1 > 0 and ficha.column - 1 <= 8 
		and 
		ficha.row + 1 > 0 and ficha.row + 1 <= 8 
		and
		fichas [ ficha.column - 1][ficha.row + 1] == nil 
		then
		--table.insert(movimientos,{ ficha.row + 1 , ficha.column - 1 })
		return true
	end

	--Arriba derecha
	if	( not ( fichas [ ficha.column + 1 ] == nil ) ) 
		and 
		ficha.column + 1 > 0 and ficha.column + 1 <= 8 
		and 
		ficha.row + 1 > 0 and ficha.row + 1 <= 8 
		and
		fichas [ ficha.column + 1][ficha.row + 1] == nil 
		then
		--table.insert(movimientos,{ ficha.row + 1 , ficha.column + 1 })
		return true
	end

	return  false
end

function Ficha:canMoveTo ( column, row )
	print("canMoveTo")
	ficha = self
	-- --Arriba izquierda
	-- if	not ( square.ficha  == nil )
	-- 	then
	-- 	return false


	if	not ( fichas[column][row]  == nil )
		then
		return false
	end

	--Arriba izquierda
	if	ficha.row - 1 == row and
		ficha.column - 1 == column 
		then
		return true

	--Arriba derecha
	elseif	ficha.row - 1 == row and
		ficha.column +1 == column 
		then
		return true

	--Abajo izquierda
	elseif	ficha.row + 1 == row and
		ficha.column - 1 == column 
		then
		return true

	--Arriba izquierda
	elseif	ficha.row + 1 == row and
		ficha.column + 1 == column 
		then
		return true
	end

	return false
end

-- function Ficha:copy()
-- 	return Ficha:new(self.x, self.y)
-- end

-- function Ficha:equals(vec)
-- 	if self.x == vec.x and self.y == vec.y then
-- 		return true
-- 	else
-- 		return false
-- 	end
-- end

return Ficha
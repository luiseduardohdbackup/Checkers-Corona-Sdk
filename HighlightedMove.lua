HighlightedMove = {}

local squareLength = math.min( display.contentWidth, display.contentHeight )
print("squareLength: "..squareLength)
local insideSquareLength = squareLength / 8
print("insideSquareLength: "..insideSquareLength)
local HighlightedMoveRadio = insideSquareLength / 2 * .8
print("HighlightedMoveRadio: "..HighlightedMoveRadio)

local HighlightedMoveSelected = false


local HighlightedMoves = {}

local onCollision = function ( HighlightedMove,  event )
	print( "event.phase: " .. event.phase )
    if ( event.phase == "began" ) then
		moveSelected = HighlightedMove
    elseif ( event.phase == "ended" ) then  
    	moveSelected = nil
    end
end
    
 
function HighlightedMove:new( column, row  )
	local object = {}
	object.name = "HighlightedMove"
	object.column = column
	object.row = row
  image = display.newRect( 0 , 0 , insideSquareLength , insideSquareLength )
  
  local xIni = display.contentCenterX -  ( insideSquareLength * 8 ) / 2 + insideSquareLength / 2
  local yIni = display.contentCenterY -  ( insideSquareLength * 8 ) / 2 + insideSquareLength / 2
  image.x = xIni + insideSquareLength * ( column - 1 )
  image.y = yIni + insideSquareLength * ( row - 1 )

  image.strokeWidth = 5
  image:setStrokeColor(180,0,200)
  image:setFillColor( 0, 0, 0, 0 )
  
  --tipo = piece.tipo
  
  table.insert(HighlightedMoves,image)
	object.image = image
  
  physics.addBody( image, { radius = insideSquareLength / 4 , density = 0, isSensor=true } )
  
  image:addEventListener( "collision", function ( event) onCollision(object, event) end ) 
  
  setmetatable(object, { __index = HighlightedMove })
  
	return object
end


function HighlightedMove:getAll()
	return HighlightedMoves
end

function HighlightedMove:deleteAll()
	print("deleteAll")
	for key,highlighted in pairs(HighlightedMoves) do 
		HighlightedMoves[key]=nil
		highlighted:removeSelf()
		highlighted = nil
	end
end

return HighlightedMove
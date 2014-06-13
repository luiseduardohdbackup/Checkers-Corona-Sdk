HighlightedPiece = {}

local squareLength = math.min( display.contentWidth, display.contentHeight )
print("squareLength: "..squareLength)
local insideSquareLength = squareLength / 8
print("insideSquareLength: "..insideSquareLength)
local HighlightedPieceRadio = insideSquareLength / 2 * .8
print("HighlightedPieceRadio: "..HighlightedPieceRadio)
--local HighlightedPieceRadio = 
local HighlightedPieceSeleccionada = false

HighlightedMove = require("HighlightedMove")


local HighlightedPieces = {}


local coloring_squares_where_piece_can_move = function ( piece )
	print("coloring_squares_where_piece_can_move")
	for key,square in pairs(blackSquares) do 
		if  piece:canMoveTo( square.column, square.row ) then
      HighlightedMove = HighlightedMove:new( square.column, square.row )
		end
	end
end

local dragBody = function ( HighlightedPiece,piece, event, params )
  
    imagenResaltado = HighlightedPiece.image
    imagenpiece = piece.image
		HighlightedPieceSeleccionada = true
		phase = event.phase
		if ( phase == "began" ) then
      coloring_squares_where_piece_can_move(piece)
	    elseif ( event.phase == "moved" ) then  
	    	imagenResaltado.x = event.x
			  imagenResaltado.y = event.y
	    	imagenpiece.x = event.x
			  imagenpiece.y = event.y
	    elseif ( phase == "ended" ) then
	    	if not ( moveSelected == nil ) then
          
	    		column = moveSelected.column
	    		row = moveSelected.row
          
          local xIni = display.contentCenterX -  ( insideSquareLength * 8 ) / 2 + insideSquareLength / 2
          local yIni = display.contentCenterY -  ( insideSquareLength * 8 ) / 2 + insideSquareLength / 2
          imagenResaltado.x = xIni + insideSquareLength * ( column - 1 )
          imagenResaltado.y = yIni + insideSquareLength * ( row - 1 )
          imagenpiece.x = xIni + insideSquareLength * ( column - 1 )
          imagenpiece.y = yIni + insideSquareLength * ( row - 1 )
          
	    		piece.getAll()[column][row] = nil
	    		piece.column  = moveSelected.column
	    		piece.row  = moveSelected.row
          HighlightedPiece:deleteAll()
          if piecesToMove == piecesBlack then
            piecesToMove = piecesWhite
          else
            piecesToMove = piecesBlack
          end
          --resaltar_pieces_que_se_pueden_mover()
          moveSelected:deleteAll()
	    		moveSelected = nil
          HighlightedPiece:highlightPossibles()
	    	else
          local xIni = display.contentCenterX -  ( insideSquareLength * 8 ) / 2 + insideSquareLength / 2
          local yIni = display.contentCenterY -  ( insideSquareLength * 8 ) / 2 + insideSquareLength / 2
          imagenResaltado.x = xIni + insideSquareLength * ( piece.column - 1 )
          imagenResaltado.y = yIni + insideSquareLength * ( piece.row - 1 )
          imagenpiece.x = xIni + insideSquareLength * ( piece.column - 1 )
          imagenpiece.y = yIni + insideSquareLength * ( piece.row - 1 )
          
          HighlightedPieceSeleccionada = false
	    	end
	    end
	-- Stop further propagation of touch event
	return true
end
    
 
function HighlightedPiece:new( piece )
	local object = {}
	object.radius = piece.radius 
	object.name = "HighlightedPiece"
	object.tipo = tipo
	object.column = column
	object.row = row
  image = display.newCircle( 0, 0, piece.radius )
  
  local xIni = display.contentCenterX -  ( insideSquareLength * 8 ) / 2 + insideSquareLength / 2
  local yIni = display.contentCenterY -  ( insideSquareLength * 8 ) / 2 + insideSquareLength / 2
  image.x = xIni + insideSquareLength * ( piece.column - 1 )
  image.y = yIni + insideSquareLength * ( piece.row - 1 )
  
	

  image.strokeWidth = 5
  image:setStrokeColor(180,0,200)
  
  tipo = piece.tipo
	if tipo == "White" then
		image:setFillColor( 255, 255, 255 )
	elseif tipo == "Black" then
		image:setFillColor( 255, 0, 0 )
	else
		print("Error: Tipo incorrecto, las opciones son \"White\" y \"Black\"")
	end
  
  table.insert(HighlightedPieces,image)
	object.image = image
  
  image:addEventListener( 
    "touch",
    function( event,params ) 
      print("touch")
      dragBody(object,piece,event,params) 
    end
  )
  physics.addBody( image, { radius = insideSquareLength / 4 } )
  
  setmetatable(object, { __index = HighlightedPiece })
	return object
end

function HighlightedPiece:canMove(piece)
	return piece:canMove()
end

function HighlightedPiece:highlightPossibles()
	print("highlightPossibles")
	for key,piece in pairs(piecesToMove) do 
		if self:canMove( piece ) then
      highlight = HighlightedPiece:new( piece )
		end
	end
end

function HighlightedPiece:getAll()
	return HighlightedPieces
end

function HighlightedPiece:deleteAll()
	print("deleteAll")
	for key,highlight in pairs(HighlightedPieces) do 
		HighlightedPieces[key]=nil
		highlight:removeSelf()
		highlight = nil
	end
end

return HighlightedPiece
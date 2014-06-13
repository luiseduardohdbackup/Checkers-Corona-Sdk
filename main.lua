-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here

--Test damas inglesas
--Draughts ?
--http://en.wikipedia.org/wiki/Draughts
os.execute('clear')
print("Checkers Corona Sdk")

--local t = os.date( '*t' )  -- get table of current date and time
--print( os.time( t ) )      -- print date & time as number of seconds

--http://docs.coronalabs.com/api/library/os/date.html
--//TODO: find how to do ISO_8601
print( os.date( "%c" ) )        -- print out time/date string: e.g., "Thu Oct 23 14:55:02 2010"

prettyPrint = require 'PrettyPrint'
--prettyOutput = PrettyPrint( someTable )



display.setStatusBar( display.HiddenStatusBar )
timer.performWithDelay( 
	    		2, 
	    		function()
	    			require("mobdebug").start()
	    		end
	    		)


system.deactivate("multitouch")
json = require("json")


local physics = require "physics"
physics.start()
--physics.setScale( 60 )
physics.setGravity( 0, 0 )
physics.setDrawMode( "hybrid" )  --overlays collision outlines on normal display objects
--physics.setDrawMode( "normal" )  --the default Corona renderer, with no collision outlines
--physics.setDrawMode( "debug" )   --shows collision engine outlines only

--//Util
function usleep(nMilliseconds)
    local nStartTime = system.getTimer()
    local nEndTime = nStartTime + nMilliseconds

    while true do 
        if system.getTimer() >= nEndTime then
            break
        end
    end
 end



board = {}
for i = 1, 8, 1 do
	board[i] = {}
	for j = 1, 8, 1 do
		board[j] = {}
	end
end
blackSquares = {}
whiteSquares = {}
piecesWhite = {}
piecesBlack = {}
piecesToMove = piecesBlack
piecesWhoCanMove = {}
piecesHighlighted = {}
movesHighlighted = {}
gameOver = false
squareLength = math.min( display.contentWidth, display.contentHeight )
print("squareLength: "..squareLength)
insideSquareLength = squareLength / 8
print("insideSquareLength: "..insideSquareLength)

Piece = require("Piece")
HighlightedPiece = require("HighlightedPiece")

local onCollision = function ( event )
	print( "event.phase: " .. event.phase )
	print( "event.target.name: " .. event.target.name )
    if ( event.phase == "began" ) then
		moveSelected = event.target
    elseif ( event.phase == "ended" ) then  
    	moveSelected = nil
    end
end

PieceSeleccionada = false

--Background in color
local background = display.newRect(0,0, display.contentWidth ,display.contentHeight)
background:setFillColor( 128, 128, 128 )  

local background = display.newRect(0,0, squareLength , squareLength)
background:setFillColor( 255, 255, 255 )  
background.x = display.contentCenterX
background.y = display.contentCenterY



--Show board
for i = 1, 8 , 1 do
	board[i] = {}
	for j = 1, 8 , 1 do	
		square =  display.newRect(0,0, insideSquareLength , insideSquareLength)
		square.name = "square"
		if ( i + j ) % 2 == 0 then
			square.colorName =  "White"
			square.color = .2 -- setFillColor( gray )
			square:setFillColor( 249, 195, 136 )
			table.insert( whiteSquares, square )
		else
			square.colorName =  "Black"
			square.color = .8 -- setFillColor( gray )
			square:setFillColor( 191, 120, 48 )
			table.insert( blackSquares, square )
		end

		column = i
		row = j
		square.column = column
		square.row = row
		board[column][row] = square
		xIni = display.contentCenterX -  ( insideSquareLength * 8 ) / 2 + insideSquareLength / 2
		yIni = display.contentCenterY -  ( insideSquareLength * 8 ) / 2 + insideSquareLength / 2
		square.x = xIni + insideSquareLength * ( i - 1 )
		square.y = yIni + insideSquareLength * ( j - 1 )
		board[i][j] = square
	end
end

for key,square in pairs(blackSquares) do 
    if  square.row <= 3 or square.row >= 6 then
		if  square.row <= 3 then
			Piece = Piece:new("White", square.column, square.row )
			table.insert(piecesWhite, Piece)
		elseif square.row >= 6 then
			Piece = Piece:new("Black", square.column, square.row )
			table.insert(piecesBlack, Piece)
		end
	end	
end
HighlightedPiece:highlightPossibles()
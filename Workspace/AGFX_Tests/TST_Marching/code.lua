
LoadScript("TCellular.lua")
LoadScript("TMarchingSquare.lua")

theme1 = {}


marchingSquares = TMarchingSquare:New();

cave = TCellular:New();
scrollPos = {}
scrollPos ={x=0,y=0}

-- The Init() method is part of the game's lifecycle and called a game starts. We are going to
-- use this method to configure background color, ScreenBufferChip and draw a text box.
function Init()


	-- Here we are manually changing the background color
	BackgroundColor(32)

	-- Let's draw the title into the tilemap
	DrawText("Marching squares", 1, 1, DrawMode.Tile, "large-font")

	SetTileTheme(16)

	cave:Generate(32,30,0.6,3,5,5);

	marchingSquares.theme = theme1;
	marchingSquares.invert = true;
	marchingSquares.mapData = cave;
	marchingSquares:BuildTilemap();

	-- dump map to log file
	cave:Dump();
end

-- The Update() method is part of the game's life cycle. The engine calls Update() on every frame
-- before the Draw() method. It accepts one argument, timeDelta, which is the difference in
-- milliseconds since the last frame.
function Update(timeDelta)

	ScrollPosition(scrollPos.x,scrollPos.y)

	if Button(Buttons.Up,InputState.Down) then scrollPos.y=scrollPos.y-1; end
	if Button(Buttons.Down,InputState.Down) then scrollPos.y=scrollPos.y+1; end
	if Button(Buttons.Left,InputState.Down) then scrollPos.x=scrollPos.x-1; end
	if Button(Buttons.Right,InputState.Down) then scrollPos.x=scrollPos.x+1; end

	if Key(Keys.A,InputState.Down) then SetTileTheme(16); end
	if Key(Keys.B,InputState.Down) then SetTileTheme(32); end

end

-- The Draw() method is part of the game's life cycle. It is called after Update() and is where
-- all of our draw calls should go. We'll be using this to render sprites to the display.
function Draw()

	-- We can use the RedrawDisplay() method to clear the screen and redraw the tilemap in a
	-- single call.
	RedrawDisplay();

	-- TODO add your own draw logic here.
	cave:PreviewMap(0,0);

end


function SetTileTheme(tile_offset)

	theme1[01] = {tile = 0 + tile_offset,flag=-1}
	theme1[02] = {tile = 1 + tile_offset,flag=-1}
	theme1[03] = {tile = 2 + tile_offset,flag=-1}
	theme1[04] = {tile = 3 + tile_offset,flag=-1}
	theme1[05] = {tile = 4 + tile_offset,flag=-1}
	theme1[06] = {tile = 5 + tile_offset,flag=-1}
	theme1[07] = {tile = 6 + tile_offset,flag=-1}
	theme1[08] = {tile = 7 + tile_offset,flag=-1}
	theme1[09] = {tile = 8 + tile_offset,flag=-1}
	theme1[10] = {tile = 9 + tile_offset,flag=-1}
	theme1[11] = {tile = 10 + tile_offset,flag=-1}
	theme1[12] = {tile = 11 + tile_offset,flag=-1}
	theme1[13] = {tile = 12 + tile_offset,flag=-1}
	theme1[14] = {tile = 13 + tile_offset,flag=-1}
	theme1[15] = {tile = 14 + tile_offset,flag=-1}
	theme1[16] = {tile = 15 + tile_offset,flag=-1}


end

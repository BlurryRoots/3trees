local M = require "lib.moses"

local gamedata = {}
gamedata.assets = {}
gamedata.doors = {}
gamedata.objects = {}

gamedata.choosing_state = {
	update = function (self, dt)
		local nextstate = self

		if 1 == gamedata.selection_counter then
			gamedata.message = 'Confirm your choice by clicking again!'
		elseif 2 == gamedata.selection_counter then
			-- change state
			gamedata.selection_counter = 0
			nextstate = gamedata.uncover_state
		else
			gamedata.message = 'Choose a tree!'
		end

		return nextstate
	end,

	draw = function (self)
	end,

	mousepressed = function (self, x, y, button)
		if 'l' == button then
			update_selected_door (x, y)
		end
	end,
}

gamedata.uncover_state = {
	update = function (self, dt)
		local nextstate = gamedata.final_selection_state

		gamedata.message = 'The host no uncovers a door!'

		uncover_unselected_noprize_door ()

		return nextstate
	end,

	draw = function (self)
	end,

	mousepressed = function (x, y, button)
	end,
}

gamedata.final_selection_state = {
	update = function (self, dt)
		local nextstate = self

		if 1 == gamedata.selection_counter then
			gamedata.message = 'Confirm your choice by clicking again!'
		elseif 2 == gamedata.selection_counter then
			-- change state
			local door = gamedata.doors[gamedata.selected_door]
			door.iscovered = false

			if door.hasprize then
				nextstate = gamedata.win_state
			else
				nextstate = gamedata.lost_state
			end

			gamedata.selection_counter = 0
			gamedata.selected_door = 0
		else
			gamedata.message = 'Do you want to reconsider your choice?'
		end

		return nextstate
	end,

	draw = function (self)
	end,

	mousepressed = function (self, x, y, button)
		if 'l' == button then
			update_selected_door (x, y)
		end
	end,
}

AGAIN = '(Right click to play again)'
gamedata.win_state = {
	update = function (self, dt)
		gamedata.message = 'You won! ' .. AGAIN

		return self
	end,

	draw = function (self)
	end,

	mousepressed = function (self, x, y, button)
		if 'r' == button then
			restart_game ()
		end
	end,
}

gamedata.lost_state = {
	update = function (self, dt)
		gamedata.message = 'You lost! ' .. AGAIN

		return self
	end,

	draw = function (self)
	end,

	mousepressed = function (self, x, y, button)
		if 'r' == button then
			restart_game ()
		end
	end,
}

function restart_game ()
	gamedata.doors = generate_doors (3)

	gamedata.message = 'Choose a tree!'
	gamedata.selection_counter = 0
	gamedata.rng = love.math.newRandomGenerator ()

	gamedata.bee_draw_states = {
		{
			head_accu = 0, head = gamedata.rng:random (1, 4),
			wing_accu = 0, wing = gamedata.rng:random (1, 3),
		},
		{
			head_accu = 0, head = gamedata.rng:random (1, 4),
			wing_accu = 0, wing = gamedata.rng:random (1, 3),
		},
		{
			head_accu = 0, head = gamedata.rng:random (1, 4),
			wing_accu = 0, wing = gamedata.rng:random (1, 3),
		},
	}

	gamedata.state = gamedata.choosing_state
end

function load_asset (key, path)
	gamedata.assets[key] = love.graphics.newImage (path)
end

function calculate_selected_door (x, y)
	local door = 0
	if y > gamedata.doory and y < (gamedata.doory + gamedata.tilewidth) then
		door = math.ceil (x / gamedata.tilewidth)
	end

	return door
end

function update_selected_door (x, y)
	local s = calculate_selected_door (x, y)
	local door = gamedata.doors[s]

	if 0 ~= s and door.iscovered then
		if gamedata.selected_door == s then
			gamedata.selection_counter = gamedata.selection_counter + 1
		else
			gamedata.selection_counter = 1
		end
	end

	gamedata.selected_door = s

	if 0 == gamedata.selected_door then
		gamedata.selection_counter = 0
	end
end

function uncover_unselected_noprize_door ()
	local searching = true

	repeat
		local i = gamedata.rng:random (1, #gamedata.doors)
		local door = gamedata.doors[i]
		local isselected = gamedata.selected_door == i
		if not isselected and not door.hasprize and door.iscovered then
			door.iscovered = false
			searching = false
		end
	until not searching
end

function generate_doors (count)
	local doors = {}
	local c = (count and count > 0) and count or 3
	if c < 3 then
		error ('There have to be at least 3 doors!')
	end

	for i = 1, c do
		doors[i] = {
			hasprize = false,
			iscovered = true,
		}
	end

	doors[1].hasprize = true

	return M.shuffle (doors)
end

function draw_tree (tilenr, x, y, sf)
	love.graphics.draw (gamedata.assets['tree'],
		x, y,
		0,
		sf, sf
	)
end

function draw_prize (tilenr, x, y, sf)
	local pot = gamedata.assets['pot']
	love.graphics.draw (pot,
		x + (gamedata.tilewidth / 2) - ((pot:getWidth () / 2) * sf),
		y + (gamedata.tilewidth / 2) - ((pot:getHeight () / 2) * sf),
		0,
		sf, sf
	)
end

function draw_bee (tilenr, x, y, sf)
	local state = gamedata.bee_draw_states[tilenr]

	love.graphics.draw (gamedata.assets['bee.body'],
		x, y,
		0,
		sf, sf
	)

	local head = 'bee.head.' .. tostring (state.head)
	love.graphics.draw (gamedata.assets[head],
		x, y,
		0,
		sf, sf
	)

	local wing = 'bee.wings.' .. tostring (state.wing)
	love.graphics.draw (gamedata.assets[wing],
		x, y,
		0,
		sf, sf
	)
end

function love.load ()
	load_asset ('tile', 'gfx/tile.grass.png')
	load_asset ('tree', 'gfx/tree.png')
	load_asset ('pot', 'gfx/honypot.full.png')
	load_asset ('bee.head.1', 'gfx/bee.head.anim.1.png')
	load_asset ('bee.head.2', 'gfx/bee.head.anim.2.png')
	load_asset ('bee.head.3', 'gfx/bee.head.anim.3.png')
	load_asset ('bee.head.4', 'gfx/bee.head.anim.4.png')
	load_asset ('bee.wings.1', 'gfx/bee.wings.anim.1.png')
	load_asset ('bee.wings.2', 'gfx/bee.wings.anim.2.png')
	load_asset ('bee.wings.3', 'gfx/bee.wings.anim.3.png')
	load_asset ('bee.body', 'gfx/bee.body.png')

	gamedata.window = {
		width = love.window.getWidth (),
		height = love.window.getHeight ()
	}

	gamedata.doory = 128

	gamedata.font = love.graphics.newFont (42)
	love.graphics.setFont (gamedata.font)

	restart_game ()
end

function love.quit ()
end

function love.focus (f)
	if f then
		-- lost
	else
		-- gained
	end
end

function love.resize (w, h)
	gamedata.window = {
		width = w,
		height = h
	}
end

function love.update (dt)
	gamedata.tilewidth = gamedata.window.width / #gamedata.doors

	gamedata.state = gamedata.state:update (dt)

	for i, door in pairs (gamedata.doors) do
		if not door.hasprize then
			local state = gamedata.bee_draw_states[i]
			if state.head_accu > 0.25 then
				state.head_accu = 0

				local nexthead = (state.head + 1) % 4
				if 0 == nexthead then
					nexthead = 1
				end

				state.head = nexthead
			else
				state.head_accu = state.head_accu + dt
			end

			if state.wing_accu > 0.33 then
				state.wing_accu = 0

				local nextwing = (state.wing + 1) % 3
				if 0 == nextwing then
					nextwing = 1
				end

				state.wing = nextwing
			else
				state.wing_accu = state.wing_accu + dt
			end
		end
	end
end

function love.draw ()
	if not gamedata.window then
		return
	end

	local ww = gamedata.window.width
	local sf = gamedata.tilewidth / gamedata.assets['tile']:getWidth ()

	love.graphics.print (gamedata.message,
		(ww / 2) - (gamedata.font:getWidth (gamedata.message) / 2),
		(gamedata.doory / 2) - (gamedata.font:getHeight () / 2)
	)

	local ndoors = #gamedata.doors
	for i = 1, ndoors do
		local x = 0 + ((i - 1) * gamedata.tilewidth)

		love.graphics.draw (gamedata.assets['tile'],
			x, gamedata.doory,
			0,
			sf, sf
		)

		local r, g, b, a = love.graphics.getColor ()
		if i == gamedata.selected_door then
			love.graphics.setColor (r, g, b, 200)
		end

		local door = gamedata.doors[i]
		local draw_door = draw_tree

		if not door.iscovered then
			if door.hasprize then
				draw_door = draw_prize
			else
				draw_door = draw_bee
			end
		end

		draw_door (i, x, gamedata.doory, sf)

		love.graphics.setColor (r, g, b, a)
	end
end

function love.mousepressed (x, y, button)
	gamedata.state:mousepressed (x, y, button)
end

function love.mousereleased (x, y, button)
end

function love.keypressed (key)
end

function love.keyreleased (key)
end


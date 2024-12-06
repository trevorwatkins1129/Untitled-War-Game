hexagon = require "lib.hexagon"

function love.load()
    -- Configure units
    unitRadius = 50
    selectedHexagon = {0, 0}
    selectedHexagonCoords = {0, 0}

    -- Load + setup world map
    world = love.graphics.newImage("img/world.jpg")
    mapSize = {world:getWidth(), world:getHeight()}

    -- Prepare hexagon overlay
    grid = hexagon.grid(mapSize[1]/unitRadius, mapSize[2]/unitRadius, unitRadius, true, false)
    gridCanvas = love.graphics.newCanvas(mapSize[1], mapSize[2])
    selectedCanvas = love.graphics.newCanvas(mapSize[1], mapSize[2])

    -- -- Init camera
    scale = 0.5
    camX = -(mapSize[1])/2 + love.graphics.getWidth()
    camY = -(mapSize[2])/2 + love.graphics.getHeight()
end

function love.draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(world, camX, camY, 0, scale)
    love.graphics.setColor(1, 0, 0)
    hexagon.drawGrid(grid, gridCanvas)
    love.graphics.draw(gridCanvas, camX, camY, 0, scale)
    love.graphics.setColor(0, 1, 0)
    if selectedHexagon[1] ~= 0 then
        drawBoldHexagon(selectedHexagonCoords[1], selectedHexagonCoords[2], unitRadius, true)
        love.graphics.draw(selectedCanvas, camX, camY, 0, scale)
    end
    love.graphics.print(selectedHexagon, 10, 10)
end

function love.mousemoved(x, y, dx, dy, touch)
    if love.mouse.isDown(1) then
        camX = camX + dx
        camY = camY + dy
    end
end

function love.wheelmoved(x, y)
    scale = math.abs(scale + (y / 3))
end

function love.mousepressed(x, y, button, isTouch, presses)
    if button == 2 then
        selectedHexagon[1], selectedHexagon[2] = hexagon.toHexagonCoordinates((x-camX) / scale, (y-camY) / scale, grid)
        if selectedHexagon[1] == -1 or selectedHexagon[2] == -1 then
            selectedHexagon = {0, 0}
        end
        selectedHexagonCoords[1], selectedHexagonCoords[2] = hexagon.toPlanCoordinates(selectedHexagon[1], selectedHexagon[2], grid)
    end
end

function drawHexagon(x, y, hexagonSize, pointyTopped)
--     love.graphics.setCanvas(gridCanvas)
    local vertices = {}

    if pointyTopped then
        table.insert(vertices, x)
        table.insert(vertices, y + hexagonSize)
        for i = 1, 5 do
            table.insert(vertices, x + hexagonSize * math.sin(i * math.pi / 3))
            table.insert(vertices, y + hexagonSize * math.cos(i * math.pi / 3))
        end
    else
        table.insert(vertices, x + hexagonSize)
        table.insert(vertices, y)
        for i = 1, 5 do
            table.insert(vertices, x + hexagonSize * math.cos(i * math.pi / 3))
            table.insert(vertices, y + hexagonSize * math.sin(i * math.pi / 3))
        end
    end
    love.graphics.polygon("line", vertices)
    -- love.graphics.setCanvas()
end

function drawBoldHexagon(x, y, hexagonSize, pointyTopped)
    love.graphics.setCanvas(selectedCanvas)
    love.graphics.clear()
    drawHexagon(x, y, hexagonSize, pointyTopped)
    drawHexagon(x, y, hexagonSize - 1, pointyTopped)
    drawHexagon(x, y, hexagonSize + 1, pointyTopped)
    love.graphics.setCanvas()
end
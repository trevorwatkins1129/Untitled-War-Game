hexagon = require "lib.hexagon"

function love.load()
    camX = 0
    camY = 0
    unitRadius = 50
    selectedHexagon = {0, 0}
    selectedHexagonCoords = {0, 0}

    world = love.graphics.newImage("img/world.jpg")
    mapSize = {world:getWidth(), world:getHeight()}

    grid = hexagon.grid(mapSize[1]/unitRadius, mapSize[2]/unitRadius, unitRadius, true, false)
    gridCanvas = love.graphics.newCanvas(mapSize[1], mapSize[2])
end

function love.draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(world, camX, camY)
    love.graphics.setColor(1, 0, 0)
    hexagon.drawGrid(grid, gridCanvas)
    love.graphics.draw(gridCanvas, camX, camY)
    love.graphics.setColor(0, 1, 0)
    love.graphics.print(selectedHexagon, 10, 10)
    if selectedHexagon[1] ~= 0 then
        drawBoldHexagon(selectedHexagonCoords[1] + camX, selectedHexagonCoords[2] + camY, unitRadius, true)
    end
end

function love.mousemoved(x, y, dx, dy, touch)
    if love.mouse.isDown(1) then
        camX = camX + dx
        camY = camY + dy
    end
end

function love.mousepressed(x, y, button, isTouch, presses)
    if button == 2 then
        selectedHexagon[1], selectedHexagon[2] = hexagon.toHexagonCoordinates(x-camX, y-camY, grid)
        if selectedHexagon[1] == -1 or selectedHexagon[2] == -1 then
            selectedHexagon = {0, 0}
        end
        selectedHexagonCoords[1], selectedHexagonCoords[2] = hexagon.toPlanCoordinates(selectedHexagon[1], selectedHexagon[2], grid)
    end
end

function drawHexagon(x, y, hexagonSize, pointyTopped)
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

function drawBoldHexagon(x, y, hexagonSize, pointyTopped)
    drawHexagon(x, y, hexagonSize, pointyTopped)
    drawHexagon(x, y, hexagonSize - 1, pointyTopped)
    drawHexagon(x, y, hexagonSize + 1, pointyTopped)
end

    love.graphics.polygon("line", vertices)
end
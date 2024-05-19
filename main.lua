function love.load() 
    logo = {}

    logo.sprite = love.graphics.newImage("assets/logo.png")
    logo.scale = 0.1
    logo.width = logo.sprite:getWidth() * logo.scale
    logo.height = logo.sprite:getHeight() * logo.scale

    logo.color = {}
    logo.pos = {}
    logo.vel = {}
    logo.speed = 10

    love.window.setMode(0, 0, {fullscreen = true, fullscreentype = "desktop"})

    reset()
end

function reset()
    math.randomseed(os.time())
    
    logo.color = choose_new_color()
    logo.pos = choose_random_pos()

    logo.vel.x = random_binary() * 2 - 1
    logo.vel.y = random_binary() * 2 - 1
end

function love.draw()
    love.graphics.setColor(logo.color.R, logo.color.G, logo.color.B, logo.color.A)
    love.graphics.draw(logo.sprite, logo.pos.x, logo.pos.y, 0, logo.scale, logo.scale)
end

function love.update(dt)
    update_pos()
    process_border_hit()
end

function love.keyreleased(key)
    if key == "r" then
        reset()
    end
end

function love.keypressed(key)
    if key == "r" then
        logo.vel.x = 0
        logo.vel.y = 0     
    end
end

function update_pos()
    logo.pos.x = logo.pos.x + (logo.vel.x * logo.speed)
    logo.pos.y = logo.pos.y + (logo.vel.y * logo.speed)
end

function process_border_hit(w, h)
    local w, h, _ = love.window.getMode()

    local top = logo.pos.y
    local left = logo.pos.x
    local bottom = top + logo.height
    local right = left + logo.width

    local hit = false

    if top <= 0 or bottom >= h then
        logo.vel.y = logo.vel.y * -1
        hit = true
    end

    if left <= 0 or right >= w then
        logo.vel.x = logo.vel.x * -1
        hit = true
    end

    if hit then
        logo.color = choose_new_color()
    end
end

function choose_new_color() 
    local c

    repeat c = {R = random_binary(), G = random_binary(), B = random_binary(), A = 1}
    until (c.R ~= logo.color.R or c.G ~= logo.color.G or c.B ~= logo.color.B) and not (c.R == c.G and c.R == c.B)

    return c
end

function choose_random_pos()
    local w, h, _ = love.window.getMode()

    local pos

    repeat pos = {x = math.random() * w, y = math.random() * h}
    until (pos.x + logo.width < w and pos.y + logo.height < h)

    return pos
end

function random_binary()
    return math.random() > 0.5 and 1 or 0
end
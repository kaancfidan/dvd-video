require "color"


function love.load()
    logo = {}

    logo.sprite = love.graphics.newImage("assets/logo.png")
    logo.scale = 0.3
    logo.width = logo.sprite:getWidth() * logo.scale
    logo.height = logo.sprite:getHeight() * logo.scale

    logo.color = {}
    logo.pos = {}
    logo.vel = {}
    logo.speed = 300

    love.window.setMode(0, 0, {
        fullscreen = true,
        fullscreentype = "desktop"
    })

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
    update_pos(dt)
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

function update_pos(dt)
    logo.pos.x = logo.pos.x + (logo.vel.x * logo.speed * dt)
    logo.pos.y = logo.pos.y + (logo.vel.y * logo.speed * dt)
end

function process_border_hit(w, h)
    local w, h, _ = love.window.getMode()

    local top = logo.pos.y
    local left = logo.pos.x
    local bottom = top + logo.height
    local right = left + logo.width

    local hit = false

    if top <= 0 and logo.vel.y == -1 then
        logo.vel.y = 1
        hit = true
    end

    if bottom >= h and logo.vel.y == 1 then
        logo.vel.y = -1
        hit = true
    end

    if left <= 0 and logo.vel.x == -1 then
        logo.vel.x = 1
        hit = true
    end

    if right >= w and logo.vel.x == 1 then
        logo.vel.x = -1
        hit = true
    end

    if hit then
        logo.color = choose_new_color()
    end
end

function choose_new_color()
    local h, s, v, a = rgb_hsv(logo.color.R, logo.color.G, logo.color.B, logo.color.A) 

    if h ~= nil then
        h = (h + math.random() * 0.2 + 0.5) % 1 -- choose a color from the other side of the wheel with random perturbance
    else
        h = math.random()
    end

    local r, g, b, a = hsv_rgb(h, 0.3, 1, 1)

    return { R = r, G = g, B = b, A = a }
end

function choose_random_pos()
    local w, h, _ = love.window.getMode()

    local pos

    repeat
        pos = {
            x = math.random() * w,
            y = math.random() * h
        }
    until (pos.x + logo.width < w and pos.y + logo.height < h)

    return pos
end

function random_binary()
    return math.random() > 0.5 and 1 or 0
end

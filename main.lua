local _ = require('src/common')
local Camera = require('src/camera')
local Map = require('src/map')
local Player = require('src/player')
local Bullet = require('src/bullet')
local media = require('src/media')
local shaders = require('src/shaders')

local camera, map

function love.load ()
  shaders.load()
  media.loadImageFont()
  media.loadBackgroundImage()
  media.playBackgroundPlaylist()

  Player.loadAssets()
  Bullet.loadAssets()

  camera = Camera.create()
  map = Map(camera)
end

function love.update (dt)
  -- update elements that are visible to the camera and not far away from radius
  local x, y, width, height = camera:getVisible()

  x = x - _.UPDATE_RADIUS
  y = y - _.UPDATE_RADIUS
  width = width + _.UPDATE_RADIUS * 2
  height = height + _.UPDATE_RADIUS * 2

  map:update(dt, x, y, width, height)
  camera:setPosition(map.player.x, map.player.y)
  camera:update(dt)
end

function love.keypressed (key)
  if key == 'lcmd' and key == 'q' then
    love.event.push('quit')
  end

  if key == 'lcmd' and key == 'r' then
    print('restart game here')
  end

  if key == 'esc' then
    print('show menu here')
  end
end

function love.draw ()
  shaders.postEffect():draw(function ()
    camera:draw(function (x, y, width, height)
      media.drawBackgroundImage()
      map:draw(x, y, width, height)
    end)
  end)

  if _.debug then
    local w, h = love.graphics.getDimensions()
    local stats = ('fps: %d, mem: %dKB, items: %d'):format(love.timer.getFPS(), collectgarbage('count'), map:countItems())

    love.graphics.printf(stats, w - 300, h - 20, 300, 'right')
  end
end

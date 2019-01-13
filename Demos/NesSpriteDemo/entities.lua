
function CreateEntityData(x, y, w, h, colorOffset)

  local data = {
    x = x,
    y = y,
    w = w,
    h = h
  }

  data.colorOffset = colorOffset or 0

  return data

end

function CreateAnimatedEntityData(x, y, w, h, colorOffset, delay)

  local data = CreateEntityData(x, y, w, h, colorOffset)

  data.spriteIDs = nil
  data.frameDelay = delay or .08
  data.currentFrame = 1
  data.frameTime = 0

  return data

end


function CreateGuyEntity(x, y, colorOffset)

  local data = CreateAnimatedEntityData(x, y, 3, 4, colorOffset)

  data.currentState = 1
  data.frames =
  {
    {guyidle1, guyidle2, guyidle3, guyidle4}, -- idle
    {guyjump1, guyjump2, guyjump3}, -- jump
    {guyrunning1, guyrunning2, guyrunning3, guyrunning4, guyrunning5, guyrunning6} -- run
  }

  data.overlayOffset = {x = 8, y = 8, w = 1}

  data.overlayFrames =
  {
    {guyidle1overlay, guyidle2overlay, guyidle3overlay, guyidle4overlay}, -- idle
    {guyjump1overlay, guyjump2overlay, guyjump3overlay}, -- jump
    {guyrunning1overlay, guyrunning2overlay, guyrunning3overlay, guyrunning4overlay, guyrunning5overlay, guyrunning6overlay} -- run
  }

  return data

end

function CreateGirlEntity(x, y, colorOffset)

  local data = CreateAnimatedEntityData(x, y, 3, 4, colorOffset)

  data.currentState = 1
  data.frames =
  {
    {girlidle1, girlidle2, girlidle3, girlidle4}, -- idle
    {girljump1, girljump2, girljump3}, -- jump
    {girlrunning1, girlrunning2, girlrunning3, girlrunning4, girlrunning5, girlrunning6} -- run
  }

  data.overlayOffset = {x = 0, y = 8, w = 3}

  data.overlayFrames =
  {
    {girlidle1overlay, girlidle2overlay, girlidle3overlay, girlidle4overlay}, -- idle
    {girljump1overlay, girljump2overlay, girljump3overlay}, -- jump
    {girlrunning1overlay, girlrunning2overlay, girlrunning3overlay, girlrunning4overlay, girlrunning5overlay, girlrunning6overlay} -- run
  }

  return data

end

function CreateZombieEntity(x, y, colorOffset)

  local data = CreateAnimatedEntityData(x, y, 3, 4, colorOffset)

  data.currentState = 1
  data.frames =
  {
    {zombierunning1, zombierunning2, zombierunning3, zombierunning4, zombierunning5, zombierunning6}, -- run
  }

  data.overlayOffset = {x = 8, y = 8, w = 1}

  data.overlayFrames =
  {
    {zombierunning1overlay, zombierunning2overlay, zombierunning3overlay, zombierunning4overlay, zombierunning5overlay, zombierunning6overlay}, -- run
  }

  return data

end

function UpdateAnimatedEntity(target, timeDelta)


  -- Increase frameTime by last frame's delta
  target.frameTime = target.frameTime + timeDelta

  -- Test to see if the frameTime is greater than the frameDelay
  if(target.frameTime > target.frameDelay) then

    -- Calculate next frame
    target.currentFrame = target.currentFrame + 1

    if(target.currentFrame > #target.frames[target.currentState]) then
      target.currentFrame = 1
    end

    -- Increase start sprite
    target.spriteIDs = target.frames[target.currentState][target.currentFrame].spriteIDs

    if(target.overlayFrames ~= nil) then
      target.spriteOverlayIDs = target.overlayFrames[target.currentState][target.currentFrame].spriteIDs
    end

    -- Reset the frame
    target.frameTime = 0

  end

end

function DrawAnimatedEntity(target)

  if(target.spriteIDs ~= nil) then
    DrawSprites(target.spriteIDs, target.x, target.y, target.w, false, false, DrawMode.Sprite, target.colorOffset, false, false)
  end

  if(target.spriteOverlayIDs ~= nil) then
    DrawSprites(target.spriteOverlayIDs, target.x + target.overlayOffset.x, target.y + target.overlayOffset.y, target.overlayOffset.w, false, false, DrawMode.Sprite, target.colorOffset, false, false)
  end

end

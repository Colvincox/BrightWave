require "setup"
require "movers"

math.randomseed(os.time())
function r(a,b)
return math.random(a,b)
end

local touch = {}
touch.x = 0
touch.y = 0
touch.down = false

local d1=display.newGroup();setup.generic(d1)
local gameLayer=display.newGroup();setup.generic(gameLayer)
local safe = setup.populater(d1,gameLayer)

safe.cc = 0;
safe.speed = 0;
safe.starshift = 0;

local function shift_tank(o)
result = {x=((640*.5-o.x)*.2 ),y=((960*.5-o.y)*.2 )}
o.x = o.x + result.x
o.y = o.y + result.y
return result 
end
local function shift_object_mod(o,shift)
o.y = (o.y + shift.y)%239
o.x = (o.x + shift.x)%239
end
local function shift_object(o,shift)
o.y = (o.y + shift.y)
o.x = (o.x + shift.x)
end
------------------------------------
function hitTestObjects(obj1, obj2,o)
        return obj1.contentBounds.xMin < obj2.contentBounds.xMax-o
                and obj1.contentBounds.xMax > obj2.contentBounds.xMin+o
                and obj1.contentBounds.yMin < obj2.contentBounds.yMax-o
                and obj1.contentBounds.yMax > obj2.contentBounds.yMin+o
end
---------------------------------------------------------
function spawn_bullet(o)
 local vv = safe.bullet
if(vv.last<=0 and touch.down)then
vv.last = 5
vv.count=vv.count+1
if(vv.count>#vv)then vv.count=1 end
local tv = vv[vv.count]
movers.calcVectorFromAngle2(tv,-o.rotation+180,25)
movers.projectFromAngle(o,tv,80)
tv.isVisible = true;
o.fx = tv.vx
o.fy = tv.vy
end
end
------------------------------------------------------
function spawn_object(o)
local vv = safe.object
local free = 0
if(vv.last<=0)then
for i = 1, #vv do
if(vv[i].isVisible == false and free == 0)then free = i end
end--for i = 1, #vv do
if(free>0)then
local tv = vv[free]
movers.projectFromAngleb(o,tv,600,(-o.rotation+180)+(r(1,180)-90))
local objects = 0 
for i = 1, #vv do 
if(movers.calcDist(tv,vv[i])<400)then objects = objects + 1 end
end
if(objects<=1)then
print("spawned")
tv.isVisible = true;
vv.last = r(60,150)
tv.life = 300
tv.hits = 0
tv.rx =tv.x
tv.ry =tv.y
end
end--if(free>0)then
end--if(vv.last<=0)then
end--function spawn_object()
-----------------------------------------------
function spawn_star(obj,degree,o)
local vv = safe.star
vv.count = vv.count +1
if(vv.count > #vv)then vv.count = 1 end
local tv = vv[vv.count]
tv.x=obj.x
tv.y=obj.y
tv.currentFrame = o
movers.calcVectorFromAngle2(tv,degree,20)
tv.isVisible = true
end
-------------------------------main  game loop
local function gameEventLoop(event)
local shift = shift_tank(safe.tank[1])
shift_object_mod(safe.nds1,shift)
----------------move tank lower
angle = movers.calcAngle(safe.tank[1],touch)
result = movers.rotate_closest(safe.tank[1].rotation,angle)
local tr = safe.tank[1].rotation
local ta = angle
if(safe.tank[1].rotation<90 or safe.tank[1].rotation>270)then tr = (tr + 180)%360;ta = (ta + 180)%360;  end
if(math.abs(tr-ta)>180+5 or math.abs(tr-ta)<180-5)then
if(touch.down)then
if(result == "CCW")then safe.tank[1].rot = safe.tank[1].rot + 2 end
if(result == "CW")then safe.tank[1].rot = safe.tank[1].rot - 2 end
end
safe.tank[1].rotation = safe.tank[1].rotation + safe.tank[1].rot
else 
safe.tank[1].rotation = angle+180
end
safe.tank[1].rot = safe.tank[1].rot * .6
if(touch.down)then safe.speed = safe.speed + 1 end
safe.speed = safe.speed *.95
movers.calcVectorFromAngle(safe.tank[1],safe.speed)
safe.tank[1].x = safe.tank[1].x + safe.tank[1].vx 
safe.tank[1].y = safe.tank[1].y + safe.tank[1].vy
----------------move tank upper
movers.moveMeXf (safe.tank[2], 0, .7, .3)
movers.moveMeYf (safe.tank[2], 0, .7, .3)
safe.tank[2].x = safe.tank[1].x - safe.tank[2].fx
safe.tank[2].y = safe.tank[1].y - safe.tank[2].fy
result = movers.rotate_closest(safe.tank[2].rotation,angle)
local tr = safe.tank[2].rotation
local ta = angle
if(safe.tank[2].rotation<90 or safe.tank[2].rotation>270)then tr = (tr + 180)%360;ta = (ta + 180)%360;  end
if(math.abs(tr-ta)>180+5 or math.abs(tr-ta)<180-5)then
if(touch.down)then
if(result == "CCW")then safe.tank[2].rot = safe.tank[2].rot + 3 end
if(result == "CW")then safe.tank[2].rot = safe.tank[2].rot - 3 end
end
safe.tank[2].rotation = safe.tank[2].rotation + safe.tank[2].rot
else 
safe.tank[2].rotation = angle+180
end
safe.tank[2].rot = safe.tank[2].rot * .7
---------------move bullet
safe.bullet.last = safe.bullet.last -1
spawn_bullet(safe.tank[2])
for i = 1, #safe.bullet do
local v = safe.bullet[i]
if(v.isVisible == true)then
v.x=v.x+v.vx
v.y=v.y+v.vy
shift_object(v,shift)
if(v.y < -50 or v.y > 960+50 or v.x < -50 or v.x > 640+50 )then
v.isVisible = false
end
for j = 1, #safe.object do
local w = safe.object[j]
if(w.isVisible == true)then
if(hitTestObjects(v, w,20))then 
v.isVisible = false
w.fx = v.vx
w.fy = v.vy
w.hits = w.hits + 1
if(w.hits>10)then w.isVisible = false end
safe.starshift = safe.starshift + 10
for i1 = 1, 8 do
spawn_star(w,((i1-1)*360/8)+safe.starshift,1)
end
end
end
end--for j = 1, #safe.object do
end
end
------------hit test objects vs tank
local v = safe.tank[1]
for i = 1, #safe.object do
local w = safe.object[i]
if(w.isVisible == true)then
if(hitTestObjects(w, v,40))then 
safe.starshift = safe.starshift + 10
for i1 = 1, 8 do
spawn_star(w,((i1-1)*360/8)+safe.starshift,1)
end
w.isVisible = false
end
end
end
---------------move object
safe.object.last = safe.object.last -1
spawn_object(safe.tank[1])
for i = 1, #safe.object do
local v = safe.object[i]
if(v.isVisible == true)then
v.x = v.rx
v.y = v.ry
shift_object(v,shift)
v.rx = v.x
v.ry = v.y
movers.moveMeXf (v, 0, .7, .3)
movers.moveMeYf (v, 0, .7, .3)
v.x = v.x + v.fx
v.y = v.y + v.fy
if(v.y < -100 or v.y > 960+100 or v.x < -100 or v.x > 640+100 )then
v.life = v.life - 1
if(v.life<=0)then v.isVisible = false end
end
if(v.y < -1000 or v.y > 960+1000 or v.x < -1000 or v.x > 640+1000 )then
v.isVisible = false
end
end
end
--------------move stars
for i = 1, #safe.star do
local v = safe.star[i]
local bpb = 100
if(v.isVisible == true)then
if( v.x < -bpb or v.x > 640+bpb or v.y>960+bpb or v.y<-bpb)then v.isVisible = false; end
v.x = v.x + v.vx
v.y = v.y + v.vy
shift_object(v,shift)
end
end
end --- local function gameEventLoop(event)
--------------------------------------------------ender
Runtime:addEventListener( "enterFrame", gameEventLoop )

local function onTouch( event )

local t = event.target
local phase = event.phase
if "ended" == phase or "cancelled" == phase then
display.getCurrentStage():setFocus( nil )
touch.down = false
return true
end
if "began" == phase or "moved" == phase then
touch.x = event.x 
touch.y = event.y 
touch.down = true
display.getCurrentStage():setFocus( t )
return true
end
return true
end
Runtime:addEventListener( "touch", onTouch )
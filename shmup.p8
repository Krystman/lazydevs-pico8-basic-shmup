pico-8 cartridge // http://www.pico-8.com
version 36
__lua__
function _init()
 --this will clear the screen
 cls(0)

 mode="start"
 blinkt=1
end

function _update()
 blinkt+=1
 
 if mode=="game" then
  update_game()
 elseif mode=="start" then
  update_start()
 elseif mode=="over" then
  update_over()
 end
 
end

function _draw()

 if mode=="game" then
  draw_game()
 elseif mode=="start" then
  draw_start()
 elseif mode=="over" then
  draw_over()
 end
 
end

function startgame()
 mode="game"
 
 ship={}
 
 ship.x=64
 ship.y=64
 ship.sx=0
 ship.sy=0
 ship.spr=2
 
 flamespr=5
 
 bulx=64
 buly=-10
 
 muzzle=0
 
 score=10000
 
 lives=1

 stars={} 
 for i=1,100 do
  local newstar={}
  newstar.x=flr(rnd(128))
  newstar.y=flr(rnd(128))
  newstar.spd=rnd(1.5)+0.5
  add(stars,newstar)
 end 
  
 buls={}
 
 enemies={}
 
 local myen={}
 myen.x=60
 myen.y=5
 myen.spr=21
 
 add(enemies,myen)
end

-->8
-- tools

function starfield()
 
 for i=1,#stars do
  local mystar=stars[i]
  local scol=6
  
  if mystar.spd<1 then
   scol=1
  elseif mystar.spd<1.5 then
   scol=13
  end   
  
  pset(mystar.x,mystar.y,scol)
 end
end

function animatestars()
 
 for i=1,#stars do
  local mystar=stars[i]
  mystar.y=mystar.y+mystar.spd
  if mystar.y>128 then
   mystar.y=mystar.y-128
  end
 end

end

function blink()
 local banim={5,5,5,5,5,5,5,5,5,5,5,6,6,7,7,6,6,5}
 
 if blinkt>#banim then
  blinkt=1
 end

 return banim[blinkt]
end

function drwmyspr(myspr)
 spr(myspr.spr,myspr.x,myspr.y)
end

function col(a,b)
 local a_left=a.x
 local a_top=a.y
 local a_right=a.x+7
 local a_bottom=a.y+7
 
 local b_left=b.x
 local b_top=b.y
 local b_right=b.x+7
 local b_bottom=b.y+7

 if a_top>b_bottom then return false end
 if b_top>a_bottom then return false end
 if a_left>b_right then return false end
 if b_left>a_right then return false end
 
 return true
end
-->8
--update

function update_game()
 --controls
 ship.sx=0
 ship.sy=0
 ship.spr=2
 
 if btn(0) then
  ship.sx=-2
  ship.spr=1
 end
 if btn(1) then
  ship.sx=2
  ship.spr=3
 end
 if btn(2) then
  ship.sy=-2
 end
 if btn(3) then
  ship.sy=2
 end
  
 if btnp(5) then
  local newbul={}
  newbul.x=ship.x
  newbul.y=ship.y-3
  newbul.spr=16
  add(buls,newbul)
  
  sfx(0)
  muzzle=6
 end
 
 --moving the ship
 ship.x+=ship.sx
 ship.y+=ship.sy
 
 --checking if we hit the edge
 if ship.x>120 then
  ship.x=120
 end
 if ship.x<0 then
  ship.x=0
 end
 if ship.y<0 then
  ship.y=0
 end
 if ship.y>120 then
  ship.y=120
 end
 
 --move the bullets
 for i=#buls,1,-1 do
  local mybul=buls[i]
  mybul.y=mybul.y-4
  
  if mybul.y<-8 then
   del(buls,mybul)
  end
 end
 
 --moving enemies 
 for myen in all(enemies) do
  myen.y+=1
  myen.spr+=0.4
  if myen.spr>=25 then
   myen.spr=21
  end
  
  if myen.y>128 then
   del(enemies,myen)
  end
 end
 
 --collision ship x enemies
 for myen in all(enemies) do
  if col(myen,ship) then
   lives-=1
   sfx(1)
   del(enemies,myen)
  end
 end
 
 if lives<=0 then
  mode="over"
  return
 end
 
 
 --animate flame
 flamespr=flamespr+1
 if flamespr>9 then
  flamespr=5
 end
 
 --animate mullze flash
 if muzzle>0 then
  muzzle=muzzle-1
 end
  
 animatestars()
end

function update_start()
 if btnp(4) or btnp(5) then
  startgame()
 end
end

function update_over()
 if btnp(4) or btnp(5) then
  mode="start"
 end
end
-->8
-- draw

function draw_game()
 cls(0)
 starfield()
 drwmyspr(ship)
 spr(flamespr,ship.x,ship.y+8)
 
 --drawing enemies
 for myen in all(enemies) do
  drwmyspr(myen)
 end
  
 --drawing bullets
 for mybul in all(buls) do
  drwmyspr(mybul)
 end
 
 if muzzle>0 then
  circfill(ship.x+3,ship.y-2,muzzle,7)
 end
 
 print("score:"..score,40,1,12)
 
 for i=1,4 do
  if lives>=i then
   spr(13,i*9-8,1)
  else
   spr(14,i*9-8,1)
  end 
 end
 
 print(#buls,5,5,7)
end

function draw_start()
 --print(blink())
 cls(1)
 
 print("my awesome shmup",34,40,12) 
 print("press any key to start",20,80,blink())
end

function draw_over()
 cls(8)
 print("game over",48,40,2) 
 print("press any key to continue",16,80,blink())
end
__gfx__
00000000000220000002200000022000000000000000000000000000000000000000000000000000000000000000000000000000088008800880088000000000
000000000028820000288200002882000000000000077000000770000007700000c77c0000077000000000000000000000000000888888888008800800000000
007007000028820000288200002882000000000000c77c000007700000c77c000cccccc000c77c00000000000000000000000000888888888000000800000000
0007700000288e2002e88e2002e882000000000000cccc00000cc00000cccc0000cccc0000cccc00000000000000000000000000888888888000000800000000
00077000027c88202e87c8e202887c2000000000000cc000000cc000000cc00000000000000cc000000000000000000000000000088888800800008000000000
007007000211882028811882028811200000000000000000000cc000000000000000000000000000000000000000000000000000008888000080080000000000
00000000025582200285582002285520000000000000000000000000000000000000000000000000000000000000000000000000000880000008800000000000
00000000002992000029920000299200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00999900000000000000000000000000000000000330033003300330033003300330033000000000000000000000000000000000000000000000000000000000
09aaaa900000000000000000000000000000000033b33b3333b33b3333b33b3333b33b3300000000000000000000000000000000000000000000000000000000
9aa77aa9000000000000000000000000000000003bbbbbb33bbbbbb33bbbbbb33bbbbbb300000000000000000000000000000000000000000000000000000000
9a7777a9000000000000000000000000000000003b7717b33b7717b33b7717b33b7717b300000000000000000000000000000000000000000000000000000000
9a7777a9000000000000000000000000000000000b7117b00b7117b00b7117b00b7117b000000000000000000000000000000000000000000000000000000000
9aa77aa9000000000000000000000000000000000037730000377300003773000037730000000000000000000000000000000000000000000000000000000000
09aaaa90000000000000000000000000000000000303303003033030030330300303303000000000000000000000000000000000000000000000000000000000
00999900000000000000000000000000000000000300003030000003030000300330033000000000000000000000000000000000000000000000000000000000
__sfx__
000100003455032550305502e5502b550285502555022550205501b55018550165501355011550010000f5500c5500a5500855006550055500455003550015500055000000000000000000000000000100000000
000100002b650366402d65025650206301d6201762015620116200f6100d6100a6100761005610046100361002610026000160000600006000060000600006000000000000000000000000000000000000000000

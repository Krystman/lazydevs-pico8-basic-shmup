pico-8 cartridge // http://www.pico-8.com
version 36
__lua__
function _init()
 --this will clear the screen
 cls(0)
 shipx=64
 shipy=64
 
 shipsx=0
 shipsy=0
 
 shipspr=2
 flamespr=5
 
 bulx=64
 buly=-10
 
 muzzle=0
 
 score=10000
 
 lives=3

 starx={}
 stary={}
 for i=1,100 do
  add(starx,flr(rnd(128)))
  add(stary,flr(rnd(128)))
 end
 
end

function _update()
 --controls
 shipsx=0
 shipsy=0
 shipspr=2
 
 if btn(0) then
  shipsx=-2
  shipspr=1
 end
 if btn(1) then
  shipsx=2
  shipspr=3
 end
 if btn(2) then
  shipsy=-2
 end
 if btn(3) then
  shipsy=2
 end
 if btnp(5) then
  bulx=shipx
  buly=shipy-3
  sfx(0)
  muzzle=6
 end
 
 --moving the ship
 shipx=shipx+shipsx
 shipy=shipy+shipsy
 
 --move the bullet
 buly=buly-4
 
 --animate flame
 flamespr=flamespr+1
 if flamespr>9 then
  flamespr=5
 end
 
 --animate mullze flash
 if muzzle>0 then
  muzzle=muzzle-1
 end
 
 --checking if we hit the edge
 if shipx>120 then
  shipx=0
 end
 if shipx<0 then
  shipx=120
 end
end

function _draw()
 cls(0)
 starfield()
 spr(shipspr,shipx,shipy)
 spr(flamespr,shipx,shipy+8)
 
 spr(16,bulx,buly)
 
 if muzzle>0 then
  circfill(shipx+3,shipy-2,muzzle,7)
 end
 
 print("score:"..score,40,1,12)
 
 lives=1
 for i=1,4 do
  if lives>=i then
   spr(13,i*9-8,1)
  else
   spr(14,i*9-8,1)
  end 
 end
 
end




-->8
function starfield()
 for i=1,#starx do
  pset(starx[i],stary[i],7)
 end
 
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
00999900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
09aaaa90000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
9aa77aa9000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
9a7777a9000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
9a7777a9000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
9aa77aa9000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
09aaaa90000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00999900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100003455032550305502e5502b550285502555022550205501b55018550165501355011550010000f5500c5500a5500855006550055500455003550015500055000000000000000000000000000100000000


local finder = {}

--------------------------------------------------------------------------------
-- Item finders for item acquiring
--------------------------------------------------------------------------------

finder.data = {}

-- withdraw money (铜钱、白银、黄金) from bank
function finder:withdraw()
  local count = inventory.get_item_count( self.item )
  count = self.count - count
  count = count > 0 and count or 1
  self:send{ 'qu ' .. count .. ' ' .. item.get_id( self.item ); complete_func = self.check_source_result }
end

-- drink water from source
function finder:drink()
  self:send{ 'drink' }
end
function finder:drink_full()
  self.result = '清水'
  self:complete()
end
trigger.new{ name = 'drink_succeed', group = 'item_finder.drink', match = '^(> )*你(喝了一口|趴在|捧起一|舀了一口|端起杯香茶|从蒙恬井中|用水瓢舀了一口)', func = finder.drink }
trigger.new{ name = 'drink_full', group = 'item_finder.drink', match = '^(> )*(你喝太多了|你已经喝得太多了|你再也喝不下了|喝那么多的凉水|虽然你还想喝)', func = finder.drink_full }

-- ask for an item from npc and get it from ground
function finder:cmd_and_get( source )
  -- if item is not on ground already, send source cmd first
  if not room.has_object( source.item ) then self:send{ source.cmd } end
  -- always get item from ground, since it's sent to ground after cmd
  self:send{ 'get ' .. item.get_id( source.item ); complete_func = self.check_inventory }
end

-- 神龙岛通行令牌
function finder:sld_lingpai()
	self:send{ 'steal 通行令牌'; complete_func = finder.sld_lingpai_check }
end
function finder:sld_lingpai_succeed()
  self:disable_trigger_group 'item_finder.sld_lingpai'
  inventory.add_item '通行令牌'
end
trigger.new{ name = 'sld_lingpai_succeed', group = 'item_finder.sld_lingpai', match = '^(> )*你成功地偷到了块通行令牌!$', func = finder.sld_lingpai_succeed }
function finder:sld_lingpai_check()
  if inventory.has_item '通行令牌' then
    self:check_source_result()
  else
    self:resume()
  end
end

-- 桃源县金娃娃
function finder:ty_fish()
  if inventory.is_wielded() then
		self:newsub{ class = 'manage_inventory', action = 'unwield', complete_func = finder.ty_fish }
  else
    self:send{ 'zhua yu' }
  end
end
function finder:ty_fish_retry()
  addbusy( 2 )
	self:send{ 'yun qi;zhua yu' }
end
function finder:ty_fish_done()
  inventory.add_item '金娃娃'
  self:check_source_result()
end
trigger.new{ name = 'ty_fish_missed', group = 'item_finder.ty_fish', match = '^(> )*你慢慢弯腰去捉那对金娃娃，一手一条，握住了金娃娃的尾巴轻轻向外拉扯，', func = finder.ty_fish_retry }
trigger.new{ name = 'ty_fish_caught', group = 'item_finder.ty_fish', match = '^(> )*你伸手到怪鱼遁入的那大石底下用力一抬，只感那石微微摇动，双掌向上猛举，', func = finder.ty_fish_done }

-- 桃源县铁舟
function finder:ty_boat()
  if not inventory.has_item '金娃娃' then
    self:newsub{ class = 'get_item', item = '金娃娃' }
  elseif room.has_object '渔人' then
    inventory.remove_item '金娃娃'
    self:send{ 'give jin wawa to yu ren' }
  else
    self:fail()
  end
end
function finder:ty_boat_succeed()
  self:disable_trigger_group 'item_finder.ty_boat'
  inventory.add_item '铁舟'
  self:check_source_result()
end
trigger.new{ name = 'ty_boat_succeed', group = 'item_finder.ty_boat', match = '^(> )*渔人给了你一艘铁舟。', func = finder.ty_boat_succeed }

-- 华山树藤
function finder:hs_shuteng()
  self:send{ 'zhe shuteng' }
end
function finder:hs_shuteng_succeed()
  inventory.add_item '树藤'
  self:check_source_result()
end
function finder:hs_shuteng_fail()
  self:fail()
end
trigger.new{ name = 'hs_shuteng_succeed', group = 'item_finder.hs_shuteng', match = '^(> )*你从树干上面折断了一些树藤。', func = finder.hs_shuteng_succeed }
trigger.new{ name = 'hs_shuteng_fail', group = 'item_finder.hs_shuteng', match = '^(> )*树藤已经被你折光了。', func = finder.hs_shuteng_fail }

-- 华山藤筐
function finder:hs_kuang()
  if not inventory.has_item '树藤' then
    self:newsub{ class = 'get_item', item = '树藤' }
  else
    self:send{ 'weave kuang' }
    inventory.add_item '藤筐'
    self:check_source_result()
  end
end

-- 黑木崖黑钥匙
-- TODO kill the guy who might appear when open shu
function finder:hmy_key()
  finder.data.hmy_key = 1
  self:send{ 'l shujia;l shuji;na shu 1 from jia;fankan shu' }
end
function finder:hmy_key_fail()
  finder.data.hmy_key = finder.data.hmy_key < 5 and finder.data.hmy_key + 1 or 1
  self:send{ ( 'na shu %d from jia;fankan shu' ):format( finder.data.hmy_key ) }
end
function finder:hmy_key_succeed()
  self:send{ '#wb 1500;open shu' }
end
function finder:hmy_key_done()
  inventory.add_item '黑钥匙'
  self:check_source_result()
end
trigger.new{ name = 'hmy_key_fail', group = 'item_finder.hmy_key', match = '^你翻看了几页，并没有什么特别之处，于是又放了回去。', func = finder.hmy_key_fail }
trigger.new{ name = 'hmy_key_succeed', group = 'item_finder.hmy_key', match = '^你突然发现这本古籍似乎重量和别的有些不同，好像有什么东西藏在这本书中。', func = finder.hmy_key_succeed }
trigger.new{ name = 'hmy_key_done', group = 'item_finder.hmy_key', match = '^你缓缓打开手中古籍的夹层，取出了钥匙。', func = finder.hmy_key_done }

-- get 金龙夺 or 火云笔 from 兵器架
function mark_source_as_invalid()  -- mark 兵器架 as invalid source for both weapons
  for _, iname in pairs{ '金龙夺', '火云笔' } do
    for _, source in pairs( item.get( iname ).source ) do
      if source.location == '桃源县练功房' then source.is_invalid = true end
    end
  end
end
function finder:ty_jia( source )
  local c = ( 'na %s from jia' ):format( source.item == '金龙夺' and 'duo' or 'bi' )
  self:send{ c; complete_func = self.check_inventory }
end
trigger.new{ name = 'ty_jia_mark_source', group = 'item_finder.ty_jia', match = '^(> )*你(从兵器架上拿出一件|已经拿过了)', func = mark_source_as_invalid }

-- get food from 蝴蝶谷小童 and 华山饭厅仆人
function finder:auto_get()
  self:newweaksub{ class = 'kill_time', duration = 3, complete_func = self.check_inventory }
end

-- get tea at 桃花岛茶房, 归云庄茶房 and 莆田少林凉亭, and get food at 桃花岛饭厅 and 归云庄饭厅
function finder:sit_and_wait( source )
  self:send{ 'sit chair' }
end
function finder:sit_and_wait_succeed( _, t )
  -- TODO mark all 3 sources as invalid for 120 seconds
  if t[ 4 ] == '一杯茶' then self:send{ 'get moli huacha' } end
  self:send{ 'stand'; complete_func = self.check_inventory }
end
function finder:sit_and_wait_fail()
  self:check_source_result()
end
trigger.new{ name = 'sit_and_wait_succeed', group = 'item_finder.sit_and_wait', match = '^(> )*(丫鬟|哑仆|仆役|小沙弥)走过来，给你(端来|倒)了(一杯茉莉花茶|一杯茶|一碗米饭)。', func = finder.sit_and_wait_succeed }
trigger.new{ name = 'sit_and_wait_fail', group = 'item_finder.sit_and_wait', match = '^(> )*(丫鬟走过来对你说|仆役走过来对你说|小沙弥走过来对你说|哑仆走过来对你打手势)', func = finder.sit_and_wait_fail }

-- get 天龙八部 books
function finder:tlbb_book( source )
  -- a temp flag is needed to get the item
  if not player.temp_flag.dlhg_bookshelf then self:newsub{ class = 'get_flag', flag = 'dlhg_bookshelf' } return end
  -- if previously failed to get a book, no more chance in this session
  if player.temp_flag.dlhg_bookshelf_failed then self:fail() end
  if type( source ) == 'table' then finder.data.tlbb_book = source.item end
  self:send{ 'fan jia' }
end
function finder:tlbb_book_got_book()
  self:newsub{ class = 'get_info', inventory = true, complete_func = finder.tlbb_book_check_inventory }
end
function finder:tlbb_book_check_inventory()
  if inventory.has_item( finder.data.tlbb_book ) then
    self:check_source_result()
  else
    self:send{ 'fan jia' }
  end
end
function finder:tlbb_book_no_more_book()
  player.temp_flag.dlhg_bookshelf_failed = true
  self:fail()
end
trigger.new{ name = 'tlbb_book_got_book', group = 'item_finder.tlbb_book', match = '^(> )*你费劲周折，终于从书架上找到一本书！$', func = finder.tlbb_book_got_book }
trigger.new{ name = 'tlbb_book_no_book', group = 'item_finder.tlbb_book', match = '^(> )*你翻了半天，结果什么也没找到。$', func = finder.tlbb_book }
trigger.new{ name = 'tlbb_book_no_more_book', group = 'item_finder.tlbb_book', match = '^(> )*你已经拿过书了，怎么还想拿？$', func = finder.tlbb_book_no_more_book }


--------------------------------------------------------------------------------
-- End of module
--------------------------------------------------------------------------------

return finder

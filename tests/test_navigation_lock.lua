-- Regression: one swipe during a spelling session must move to exactly
-- the next word; overlapping callbacks must not enqueue duplicate advances.
package.preload['ui/font'] = function() return {getFace=function() return {} end} end
package.preload['ui/widget/inputdialog'] = function()
  return {new=function(_, cfg)
    cfg.text = cfg.input or ''
    function cfg:getInputText() return self.text end
    function cfg:setInputText(v) self.text=v end
    function cfg:onShowKeyboard() self.keyboard_shown=true end
    if cfg.edited_callback then cfg.edited_callback(false) end
    return cfg
  end}
end
local queue = {}
package.preload['ui/uimanager'] = function()
  return {
    show=function(self,d) self.last=d end,
    close=function(self,d) self.closed=d end,
    unschedule=function() end,
    scheduleIn=function(self,delay,fn) queue[#queue+1]={delay=delay,fn=fn} end,
    runNext=function() local item=table.remove(queue,1); if item then item.fn() end end,
  }
end
package.preload['spellingoverlay'] = function() return {new=function() return {} end} end
local S = dofile('koreader/plugins/wordscreen.koplugin/spelling.lua')
local store={}
local p={
  current_file='pet.pdf', playing=true, mode='all', spelling_active=false,
  task=function() end, start_task=function() end,
  settings={readSetting=function(_,k,d) return store[k] or d end,
    saveSetting=function(_,k,v) store[k]=v end, flush=function() end},
  ui={document={getPageText=function() return {{y0=110,{word='backpack'}}} end,
    getPageDimensions=function() return {h=1024} end}},
  isSupported=function() return true end,
  stop=function(self) self.playing=false; self.mode=nil end,
  wordCount=function() return 30 end,
  currentWordFromReader=function() return 1 end,
  gotoPage=function(self,n) self.page=n end,
  readerPage=function(self) return self.page or 1 end,
  pageCount=function() return 60 end,
  refreshHeart=function() end, notice=function(self,m) self.last_notice=m end,
}
S.start(p,21,false)
assert(p.playing == false and p.mode == nil, 'spelling must take exclusive control from player')
assert(p.spelling_word == 21 and p.page == 42, 'session must start at requested word')
S.closeKeyboard(p)
S.step(p,1)
assert(p.spelling_word == 22 and p.page == 44, 'first swipe must target word 22')
assert(p.spelling_transitioning == true, 'transition lock must remain until target settles')
S.step(p,1)
assert(p.spelling_word == 22 and p.page == 44, 'duplicate swipe must not jump to word 23')
assert(#queue == 1, 'only one keyboard reopen callback should be queued')
require('ui/uimanager').runNext()
assert(p.spelling_transitioning == false, 'transition lock must release after target settles')
assert(p.spelling_input and p.spelling_input.keyboard_shown, 'keyboard must reopen on word 22')
print('PASS: player takeover, word-22 target, duplicate-swipe lock, single keyboard reopen')

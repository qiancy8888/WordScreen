package.preload['ui/font'] = function() return {getFace=function() return {} end} end
package.preload['ui/widget/inputdialog'] = function()
  return {new=function(_, cfg)
    cfg.text = cfg.input or ''
    function cfg:getInputText() return self.text end
    function cfg:setInputText(v) self.text=v end
    function cfg:onShowKeyboard() self.keyboard_shown=true end
    -- KOReader InputText:initTextBox() invokes edited_callback during
    -- InputDialog:new(), before the local `dialog` receives this object.
    if cfg.edited_callback then cfg.edited_callback(false) end
    return cfg
  end}
end
package.preload['ui/uimanager'] = function()
  return {show=function(self,d) self.last=d end, close=function(self,d) self.closed=d end,
    scheduleIn=function(self,_,fn) fn() end}
end
package.preload['spellingoverlay'] = function() return {new=function() return {} end} end
local S = dofile('koreader/plugins/wordscreen.koplugin/spelling.lua')
local store={}
local answers={'backpack','book'}
local p={
  current_file='pet.pdf', spelling_active=false,
  settings={readSetting=function(_,k,d) return store[k] or d end,
    saveSetting=function(_,k,v) store[k]=v end, flush=function() end},
  ui={document={getPageText=function(_,page) return {{y0=110,{word=answers[math.floor(page/2)]}}} end,
    getPageDimensions=function() return {h=1024} end}},
  isSupported=function() return true end,
  stop=function() end, wordCount=function() return 2 end,
  currentWordFromReader=function() return 1 end,
  gotoPage=function(self,n) self.page=n end,
  readerPage=function(self) return self.page or 1 end,
  pageCount=function() return 4 end,
  refreshHeart=function() end, notice=function(self,m) self.last_notice=m end,
}
S.start(p,1,false)
assert(p.spelling_active and p.spelling_word==1 and p.page==2)
assert(p.spelling_input and p.spelling_input.keyboard_shown)
p.spelling_input.text='ackpack'; p.spelling_input.edited_callback()
assert(p.spelling_word==2, 'correct should auto advance')
assert(p.spelling_input.text=='', 'next word should clear entry')
p.spelling_input.text='ookx'; p.spelling_input.edited_callback()
assert(p.spelling_locked and p.spelling_guess=='ook', 'wrong should reveal correct missing letters')
assert(store.spelling_mistakes['pet.pdf']['2'].active == true)
assert(store.spelling_mistakes['pet.pdf']['2'].count == 1)
assert(p.spelling_input == nil, 'wrong answer must close modal keyboard host to release reader swipes')
assert(require('ui/uimanager').closed ~= nil, 'keyboard host should be closed')
S.step(p,1)
assert(p.spelling_word == 1, 'manual next should move to next word')
assert(p.spelling_input and p.spelling_input.keyboard_shown, 'keyboard should reopen for next word')
print('PASS: constructor callback guard, auto keyboard, live callback, correct auto-advance, wrong reveal, persistent mistake, swipe-unblock and keyboard reopen')
# DimCaverns

This is a game I am working on for the soon to be released Playdate handheld game console (https://play.date/). There isn't all that much here yet, but I wanted to at least start getting feedback sooner than later. Please take a look and give feedback! I am more looking for feedback on the code right now, but if you have some good gameplay feedback as well I'll take it.

What I'm looking for feedback on (in no real order):

- How to make my code more idiomatic lua
- How to better organize structure the game.
- How to make the game more memory efficient. (the map generation part can bump up in 16mb+ and 16mb is the total amount that will be on the playdate. The mapSize var in main.lua is currently set to 70, but much above that and it will blow through the 16mb.)
- How to make the game quicker. Specifically the map generation part, it quickly gets more computationally expensive the larger the map.
- Feedback on the mapper.lua algorithm in general.
- A good was to do animation. Right now I have the three animation files in the repo that aren't being used right now. They work okay but I feel like there could be a bit better of a way
- How to better relate the big map (the canonical, full map), small map (the subset of the big map that is drawn to the screen), the player, and any other entities that will be later implemented.
- Any other feedback you have that I haven't listed.

If anyone has enough feedback and would be willing, I'd love to do a zoom call or something to get some deeper, more fleshed-out feedback.

DimCaverns.html is a quick way to give it a try is you don't want to setup lua/love2d. If you view it this way the cli output is in the dev console. Thanks to Bernhard Schelling: https://github.com/schellingb/LoveWebBuilder for the quick and easy tool.
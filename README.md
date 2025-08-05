![circuits logo](https://img.itch.zone/aW1nLzIyNDc2OTMxLnBuZw==/original/hm2pDJ.png)
***/// AVOID CLOSED LOOPS ///***

--- 

CIRCUITS is a shoot-em-up with a unique damage mechanic, made solo in 96hr for the GMTK Game Jam. Enemies try to connect to you. If a positive enemy or a negative enemy connects to you, you're safe. But if both connect to you at the same time, you short out.


Fight back against the increasingly difficult enemies with your blaster, or make use of the 4 kinds of pickups scattered around the map.

[Play](https://dimaverse.itch.io/circuits) and [rate](https://itch.io/jam/gmtk-2025/rate/3776991) on itch.io.

---

\
CIRCUITS was made in Godot, with sound effects from Chiptone and art in Aseprite. This is the source of the game! You can download the game as a .zip and open it in Godot 4.4 to poke around my terribly unoptimized code. 

![main menu](https://img.itch.zone/aW1hZ2UvMzc3Njk5MS8yMjQ3NzY2MS5wbmc=/original/DzRqH8.png)

![gameplay](https://img.itch.zone/aW1hZ2UvMzc3Njk5MS8yMjQ3NzY1OS5wbmc=/original/78c5ic.png)

I learned a lot from this project.

- keep your future self in mind. I made the terrible decision of making two files for each type of enemy (+ and -), but each file shared 99% of the code. This led to multiple situations where I was confused as to why something wasn't working when I had only changed it in one of the files. This also slowed down my process a lot.

- optimization is important. this was my first game where I had 150+ enemies loaded at the same time, all doing computationally expensive vector math every. single. frame. in hindsight, I really should have prioritized performance earlier in the jam, rather than applying some half-baked fixes one hour before submissions closed. this leads me to my next point:

- test early and often. i didn't even *know* about the peformance issues until there were ~20 hours left in the jam, because they only appeared lategame when there are a lot of enemies.

- call down, signal up. this rule would have saved me hours of debugging, and stopped limitless random crashes. this would have simplified the codebase 10x and made the game much easier to work with.

- sound effects are the best thing you can possibly add to your game. seriously. i spent ~30m playing around in chiptone to make some sound effects for every big action, and it made the game feel sooo much funner to play

- screen shake is good! it's very juicy but remember to include a toggle for accessibility reasons

---

thanks for playing!

\<hex4::\>
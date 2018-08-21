# ASCIIrinth [![View ASCIIrinth on Indie DB](http://media.indiedb.com/images/global/indiedb.png)](http://www.indiedb.com/games/asciirinth)
![issues](https://img.shields.io/github/issues/Phoenix1747/ASCIIrinth.svg?style=for-the-badge) ![open pr](https://img.shields.io/github/issues-pr-raw/phoenix1747/ASCIIrinth.svg?style=for-the-badge) ![GitHub last commit](https://img.shields.io/github/last-commit/phoenix1747/ASCIIrinth.svg?style=for-the-badge)

In ASCIIrinth your are finding your way through a labyrinth of ASCII characters to get from point A to point B. Why would you do that? Well, why not!

Before you get started reading, please note that this is the repository with the source code & more detail about the installation, requirements and how to make maps. If you are more interested in media, i.e. screenshots, gameplay or nice random articles, you're warmly invited to have a look at my [IndieDB](http://www.indiedb.com/games/asciirinth) page.

---

## Introduction

ASCIIrinth is, at this moment, all about finding your way out of a maze of ASCII characters. The focus is on modularity and as few requirements as possible. It's another small experiment of mine all about how to make a small terminal-based game from scratch.

You can already load and play any compatible map or create your own maps with the included map maker (it's really easy). The game works with any map size, any map structure, any player char and any goal char. There are only few things that you have to consider when making maps, more of that later. There's also a settings tab for the game, it will be advanced in the course of development. To date, you can change the controls and choose from the arrow keys and WASD and you can set a custom key for pausing the game. There is also an integrated map maker and therefore another menu that let's you choose your default map, i.e. the map that you want to play. This way you can find your way through an endless number of awesome mazes!

The cool thing about this game is that you can play it on your graphical installation, on an SSH server, on a headless server, on any OS that supports BASH, etc. - without any installation or any extravagant requirements.

**What's ASCIIrinth not...**
- a fancy graphical game
- an action game
- a system-demanding 60GB AAA title
- (very) thrilling

**What is ASCIIrinth then?**
- a puzzle game (think!)
- straightforward
- tiny in size and requirements

---

## Installation

First things first, there is no such thing as installation. Since this is the case, here you have the instructions on how to get it to play:

1. Head to the [release section](https://github.com/Phoenix1747/asciirinth/releases) and grab the latest release.
2. Unzip it and enter the newly created directory.
3. Type in `bash asciirinth` **or** `chmod +x asciirinth` and then `./asciirinth`.
4. Optional: Put any custom maps in the folder `maps`.
5. Enjoy!

---

## Requirements

ASCIIrinth does indeed have some requirements. However, those should be absolutely no problem on any reasonably up-to-date system (except Windows, duh).

* BASH version 4 or above
* sed
* find
* grep
* wc

If you're using Linux and didn't strip away half of the system, this will pose no problem for you at all. I don't know about OSX, but I guess there should be no big problems with this either. Windows, yeah... in the best case you have Windows 10, then you can easily use the Linux Subsystem, otherwise you'll need a BASH replacement. If you don't know how to get such a thing, you could, for example, download [git](https://git-scm.com/download/win) - it's a bit overkill but it ships with BASH and works fine with this game (tested it).

---

## Making Maps

You can easily create maps if you open an editor of your choice, create a new txt file and just type in every character that the map should contain. Every character and line you type will be taken one-to-one into the map file. There are no special characters or anything similar. This also means that the map maker will, in the process of generating the map file, not make any special spacing or converting. After saving the txt file, start the game and head to `'Create Map'`, there you will see all of this information and be able to convert it to the appropriate .map format.

Once again, this will convert any txt file to a compatible .map file for the game. Your map will be shown exactly like you specified it to look like!

**Requirements:**

* The player character is defined by an `O` (capital `o`!).
* The goal is defined by the character `*`.
* Accessible space is created with SPACEs.
* Do not use commas `,` anywhere.
* At the end of the file should be a blank line otherwise it won't load correctly later on.

---

## Modding

Mods are disabled by default, so if you want to use them, enable them in the game options. Note that all maps

Mods for ASCIIrinth are basically shell (sh) scripts that are being executed after the core elements of the game have been imported.
So if you plan to make mods for ASCIIrinth, you only need to know shell/BASH basics. You should also get familiar with the game's
code so that you know which variables can be safely modified - after all it basically comes down to modifying variables.

What can you actually mod for example:
* Change the standard win message.
* Most of the colors from the menu and in-game.
* You could also change settings, although you have to be careful to not break anything.
* You could theoretically build a whole new menu around the core of the game.

All in all just experiment with the game, you can do much but might also break things if you're not careful. When finished, just save it as `sh` file and upload it anywhere.
In addition you could also open a pull request with your mod and maybe it'll be included in the game.

In the future, I might also be able to make ASCIIrinth more suitable for modding so stay tuned!

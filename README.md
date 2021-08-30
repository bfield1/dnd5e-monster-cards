# monster5e
## A LaTeX class for creating monster stat block reference cards for Dungeons and Dragons 5th edition.

Copyright (C) 2021 Bernard Field
This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.


Monster stat blocks included in this repository are copyright Wizards
of the Coast and are used under the Open Game License v1.0a. 

## Introduction

When running D&D, I like to have reference cards for things like monster stat
blocks. With reference cards, rather than having to flick between pages of the
Monster Manual, I can have all relevant stat blocks present on the table in
front of me.

This LaTeX class is a way for me to consistently format these cards and to
reduce some of the duplication in formatting and typing.

This class includes key-word based population of key parts of the stat block,
automatic calculation of modifiers from ability scores and XP from CR, and
macros for headers, attacks, and abilities in the main body of the stat block.

The intent of this class is that you will print and cut out the documents
created. Formatting minimises gaps between cards, and it has the capability to
print card backgrounds.

You might like a different formatting. That's fine. This class should be simple
enough to edit if you prefer different styles.

## Usage

For examples of the usage of this class, I recommend inspecting the Example.tex
file and included files in DnD\_Monsters.

### Preamble

The preamble should include
```TeX
\documentclass{monster5e}
\setBackground{MonsterBackground}
```
where you can replace MonsterBackground with another file that you want for the
background.

In my preamble, I also include the following code:
```TeX
\newcommand{\ddir}{DnD_Monsters/}
\newcommand{\Input}[1]{\input{\ddir #1}\unskip}
```
I then include my stat blocks in separate .tex files and insert them into the
main .tex file using the new \Input macro. The `\unskip` is important to
prevent `\input` from inserting unwanted whitespace. This step is optional,
though. You can use your own workflow if you like.

### Document

In the document, call `\monsterCard` to draw a card. Do not put whitespace
between cards on the same line. Three cards fit on a line and six on a page.

If you want to include card background, use `\sixMonsterBackgrounds` to draw
the card backgrounds, doing so once every six cards.

### monsterCard

```TeX
\monsterCard[<keyword>=<argument>]{<body>}
```
This command is the primary command in this class. It generates a card with its
stat block. It occupies one sixth of an A4 page.
Note that the formatting can get funny if the body text overflows from the
card. If this occurs, you should either edit the body text to take up fewer
lines, or use the scale keyword argument to shrink the text.
Keyword arguments use PGF-TikZ, meaning you have the keyword (which may contain
spaces), followed by an '=' sign, followed by the argument (which may contain
spaces). Keyword arguments are delimited by commas. If the argument contains a
comma, then the argument must be enclosed in curly braces.
monsterCard accepts the following keyword arguments:

- title : the name of the monster.
- type : a subheading, where you can write the size, type, and alignment.
- source : optional. For citing the relevant reference book.
- str, dex, con, int, wis, cha : integer between 0 and 30. Abilty scores.
- cr : Challenge rating. If an integer between 0 and 30, or 1/8, 1/4 or 1/2,
	then it automatically calculates the associated XP.
- ac, hp, speed : Fields for AC, HP, and speed respectively.
- languages : Field for languages. If left blank, defaults to 'None'.
- condition immunities, damage immunities, resistances, saves, senses, skills,
	vulnerabilities: optional fields. Does not display if not included.
- scale : number (optional). Quantity by which to scale body text by. Title,
	type, source, and ability scores are not scaled. Use this if you have
	too much text to fit within a card at normal font size, although you
	should try to edit the body text to use less space first.

### Formatting monster abilities

Fill the body of `\monsterCard` with these bits of formatting.

```TeX
\ability{<name>}{<description>}
```
For most abilities. Give it the name and description.

```TeX
\MeleeAttack{<name>}{<targeting>}{<hit>}
\MeleeRangedAttack{<name>}{<targeting>}{<hit>}
\MeleeThrownAttack{<name>}{<targeting>}{<hit>}
\RangedAttack{<name>}{<targeting>}{<hit>}
\MeleeSpellAttack{<name>}{<targeting>}{<hit>}
\RangedSpellAttack{<name>}{<targeting>}{<hit>}
```
For attacks. Include the name of the attack/weapon (e.g. Sword), then the
targeting information (e.g. "+4 to hit, reach 5ft, one target."), then the
body description for what happens on a Hit (e.g. "1d8+3 slashing damage").
(MeleeThrownAttack does not appear in official stat blocks, which instead
used MeleeRangedAttack. However, I like to differentiate between the cases
of a ranged weapon or a thrown weapon.)

```TeX
\attack{<name>}{<type>}{<targeting>}{<hit>}
```
As above, but includes the type field, which indicates the type of attack
(e.g. "Melee", "Ranged"). For if the previous macros miss an attack type.

```TeX
\spells{<type>}{<spells>}
```
For listing spells, typically after an `\ability{Spellcasting}{<description>}`
block. Specify the type of spell along with the number of uses
(e.g. "Cantrips (at will)", "1st level (3 slots)"), then list the spells.

```TeX
\Actions
\BonusActions
\Reactions
```
Section headings for actions, bonus actions, and reactions respectively.
(Bonus actions don't get a dedicated section in official stat blocks, instead
occupying the space before Actions. But I like to differentiate them.)

```TeX
\abilityheader{<text>}
```
Generic section heading with user-specified text.

```TeX
\LegendaryActions{[uses]}
```
Section heading for legendary actions. Optionally allows specifying how many
legendary actions the creature gets (defaults to 3).

### Card Backgrounds

```TeX
\setBackground{<file>}
```
Sets the graphics file to be used as the card background (via `\includegraphics`).
I assume the file is a 446 x 470 pixel image. Formatting might not work
properly if this is not the case (you might have a few pixels lee-way, but I
haven't tested it).

```TeX
\sixMonsterBackgrounds
```
Draws six card backgrounds, enough to fill a full page.

```TeX
\monsterBackground
```
Draws a single card background.

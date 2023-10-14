// Define some variables we will be using
VAR charm = 0 // The idea is to get the charm from the game stat (somehow)
CONST threshold1 = 5 // Threshold charm for passing if you passed only one choice
CONST threshold2 = 3 // The same, but for passing two choices
CONST NPC = "Leech" // This is the character you are talking to.
VAR current_char = NPC // This variable tracks the currently talking character. It will be passed to the "current talker" box every time dialogue is continued
// Let's flag the number of times we make the correct choice
VAR choicespassed = 0
// VAR charmgain = 0 // Tracks the amount of charm gained in the flirt
// And this one tells us if the flirt has been passed
VAR flirtpassed = false
/* This variable determines whether the character box is displayed
Set it to false whenever you need the character box to be hidden.
e.g. for narrating a scene.
Set it to true whenever you need a character talking.
*/
VAR enable_charbox = true

-> main
== function swap_char() ==
// Toggles between "Tessie" and the character being talked to
{
- current_char == "Tessie": 
    ~ current_char = NPC 
- else:
    ~ current_char = "Tessie"
}
== function force_char(char) ==
{
- current_char != char:
    ~ current_char = char
}
== main ==
/* We are assuming that NPC starts the dialogue.
If Tessie is to start the dialogue, call force_char("Tessie")
by surrounding that function name with curly brackets.

Call swap_char() to switch the character in the character box between Tessie and the NPC
You may do this in between lines of dialogue.
For an example of applying this see the Shrimp script.

For a correct option (I assume bolded in the script),
add the following line at any point after the bullet point following the corresponding choice,
but before the bullet point for the next choice (or the hyphen that "gathers").
~ choicespassed += 1

For a particularly endearing choice, you could increase the variable by 2 (or more).

If you want to penalize a player harshly for making a bad choice,
you can manipulate the choicespassed variable to your liking.
Maybe subtract 1 from it. Or even set it to zero or negative (for an immediate failure). Your call.
*/
Hey there, come a little closer. I'm Leech. How's it going?// Please do
* [Be Polite]
    {swap_char()}
    I'm good thanks! How about you?
    {swap_char()}
    I'm not too bad - but enough about me!
* [Be Charmed]
    {swap_char()}
    Hi! I'm Tessie! It's nice to meet you, Leech.
    {swap_char()}
    And you, my dear friend! I can already tell we're going to be good friends. 
    ~ choicespassed += 1
* [Act disgusted]
    {swap_char()}
    Oh, gross, I don't like leeches.
    {swap_char()}
    That may be so - but maybe we can start off with a clean slate regardless?
{force_char(NPC)} // No guarantee that the current character is the NPC after choice 1
- What're your thoughts on the taste of blood? Any vintages you prefer? // Yes, please do
* [Classy Answer]
    {swap_char()}
    You know, I've heard that human blood is an acquired taste - although I've never had it myself.
    {swap_char()}
    My friend, it certainly sounds like you know your way around the fine things in life.
    ~ choicespassed += 1
* [Simple Answer]
    {swap_char()}
    I'm not too bothered - I'll eat or drink anything that's good for me.
    {swap_char()}
    My friend, it sounds like I need to teach you how to really appreciate luxury.
* [Queasy Answer]
    {swap_char()}
    I try my best not to think about the taste to be honest...
    {swap_char()}
    Your words hurt me! And I thought we were friends...
{force_char(NPC)} // No guarantee that the current character is the NPC after choice 2
- This great stink has been a lot of fun, hasn't it? // Absolutely, please do
* [Be Honest]
    {swap_char()}
    Maybe for you, but I much prefer the water to be clean.
    {swap_char()}
    Well we can certainly agree to disagree - I'll enjoy my comforts, I think.
* [Agree]
    {swap_char()}
    Indeed - all this mess has certainly brought a new look to the river.
    {swap_char()}
    As they say, my dear friend - one fish's mess is another fish's measure.
    ~ choicespassed += 1
    {swap_char()}
    I don't think they say that...
    {swap_char()}
    Alas!
* [Disagree Boldly]
    {swap_char()}
   You know what! No! 
   I hate this dirty water! 
   And I'm gonna do whatever it takes to make it right!
   {swap_char()}
   Fiery words from a fiery heart! A shame that our tastes differ so much...
{force_char(NPC)} // The NPC will be having the final say
- /* Flirt decision here (the hyphen acts as a gather - please don't remove)
I'll assume that passing all three choices is an automatic success,
failing all three choices is an automatic failure,
and ending up in between will leave your chances of success to your charm stat.
*/
{ 
- choicespassed >= 3: // If you decide that some options are worth more than others
    ~ flirtpassed = true
- choicespassed == 2 && charm >= threshold2:
    ~ flirtpassed = true
- choicespassed == 1 && charm >= threshold1:
    ~ flirtpassed = true
- else:
    ~ flirtpassed = false
}
{ 
- flirtpassed:
    I see it's about time to be off! May we see each other soon, my dear friend!
    /* We can add charm proportional to how many choices we passed.
    Here we assume that every correct choice gains you 1 charm.
    If you would like to vary the amount of charm gained from each correct choice,
    you can declare a separate "charm gain" variable and increment it
    after every correct choice - I have commented out such a variable
    */
    ~ charm += choicespassed
    ~ enable_charbox = false // Disable the character box for this message
    {NPC} has been charmed by your flirt!
    Your charm has increased to {charm}!
- else:
    Hmm. I bid you farewell.
    // Do you want to add some consolation charm? Not sure if it makes sense to do so
    ~ enable_charbox = false
    {NPC} has left.
}
-> END
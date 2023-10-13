// Define some variables we will be using
VAR charm = 0 // The idea is to get the charm from the game stat (somehow)
CONST threshold1 = 5 // Threshold charm for passing if you passed only one choice
CONST threshold2 = 3 // The same, but for passing two choices
CONST NPC = "Sheep" // This is the character you are talking to.
VAR current_char = NPC // This variable tracks the currently talking character. It will be passed to the "current talker" box every time dialogue is continued
VAR choicespassed = 0 // Flags the number of times we make the correct choice
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

Hi! What's going on? // Prompt 1
* [Serious]
    {swap_char()}
    There's a flood right now. You've been swept into the river.
    {swap_char()}
    Oh no! What should I do?
* [Gentle]
    {swap_char()}
    Um, I think you may have been displaced...
    {swap_char()}
    Huh? What's that mean?
* [Aggressive]
    What do you mean, "what's going on"? What are you, He-man?
{force_char(NPC)} // No guarantee that the current character is the NPC after choice 1
- Why am I wet? // Prompt 2
* [Meme]
    {swap_char()}
    Because water is wet.
    {swap_char()}
    Is it though? I guess...
* [Truthful]
   {swap_char()}
   Because you're in a body of water right now.
   {swap_char()}
   Oh yeah. Good thing I can swim a little bit.
* [Philosophical]
    {swap_char()}
    Why is anyone wet?
    {swap_char()}
    That's kind of weird to ask.
{force_char(NPC)} // No guarantee that the current character is the NPC after choice 2
- What should I do now? // Prompt 3
* [Simple]
    {swap_char()}
    Swim to land?
    {swap_char()}
    Good point!
* [Encouragement]
    {swap_char()}
    Always do your best, no matter what you're doing!
    {swap_char()}
    But what am I doing, though?
* [Indifferent]
  {swap_char()}
  I don't know.
  {swap_char()}
  Same.
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
    Thanks for your help!
    ~ charm += choicespassed
    ~ enable_charbox = false // Disable the character box for this message
    {NPC} has been charmed by your flirt!
    Your charm has increased to {charm}!
- else:
    Well, nice seeing you.
    ~ enable_charbox = false
    {NPC} has left.
}
-> END
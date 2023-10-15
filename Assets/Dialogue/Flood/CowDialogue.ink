// Define some variables we will be using
VAR charm = 0 // The idea is to get the charm from the game stat (somehow)
VAR threshold1 = 0 // Threshold charm for passing if you passed only one choice
VAR threshold2 = 0 // The same, but for passing two choices
CONST NPC = "Cow" // This is the character you are talking to.
VAR current_char = NPC // This variable tracks the currently talking character. It will be passed to the "current talker" box every time dialogue is continued
VAR choicespassed = 0 // Flags the number of times we make the correct choice
VAR frustration = false // Flags whether to play a specific line based on choices made
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

Mooooo. // Prompt 1
* [Moo Back]
    {swap_char()}
    Mooooo.
    {swap_char()}
    Mooooooooo.
    ~ choicespassed += 1
* [Soothe]
    {swap_char()}
    Hey there, it's ok. Don't worry, it's all gonna be ok.
    {swap_char()}
    Moo! Moo!
* [Ask Question]
    {swap_char()}
    Hey, are you okay? Where did you get washed away from?
    {swap_char()}
    Moooooo! Mooo!
{force_char(NPC)} // No guarantee that the current character is the NPC after choice 1
- Mooo mooooooo. // Prompt 2
* [Moo Back]
    {swap_char()}
    Mooo mooooooo.
    {swap_char()}
    Moooooo.
    ~ choicespassed += 1
* [Try to understand]
    {swap_char()}
    Do you even say anything other than moos? Do you even understand anything other than moos?!
    {swap_char()}
    Moooooooooooo! Moooooo!
    ~ frustration = true
* [Moo a question]
    {swap_char()}
    Moo mooooo mooooo moo mooooooo?
    {swap_char()}
    Moooo mooo moo mooooooo!
    ~ choicespassed += 1
{force_char(NPC)} // No guarantee that the current character is the NPC after choice 2
- Moooooo mooo moooooo. // Prompt 3
* [Moo Back]
    {swap_char()}
    {
    - frustration:
        \*sigh\*
    }
    Moooooo mooo moooooo.
    {swap_char()}
    Mooooooooooooooo.
* [Moo]
    {swap_char()}
     {
    - frustration:
        \*sigh\*
    }
    Moooooooooooo.
    {swap_char()}
    Mooo!
* [Just Moo]
   {swap_char()}
    {
    - frustration:
        \*sigh\*
    }
   Moo.
   {swap_char()}
    Moooooooooo! Mooooo! Mooooooooooo!
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
    Moooooooooooo.
    ~ charm += choicespassed
    ~ enable_charbox = false // Disable the character box for this message
    {NPC} has been charmed by your flirt!
    Your charm has increased to {charm}!
- else:
    Moo.
    ~ enable_charbox = false
    {NPC} has left.
}
-> END
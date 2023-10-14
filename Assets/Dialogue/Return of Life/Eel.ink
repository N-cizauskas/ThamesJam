// Define some variables we will be using
VAR charm = 0 // The idea is to get the charm from the game stat (somehow)
CONST threshold1 = 5 // Threshold charm for passing if you passed only one choice
CONST threshold2 = 3 // The same, but for passing two choices
CONST NPC = "Eel" // This is the character you are talking to.
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

Why, hello there... what brings a charmer like you to these parts?// Prompt 1
* [Flirt]
    {swap_char()}
    A beauty like you does.
    {swap_char()}
    My, my, my... you're something special!
    ~ choicespassed += 1
* [Honest]
    {swap_char()}
    I just woke up in this time period, I'm here to check out how things are going!
    {swap_char()}
    That sounds rather boring...
* [Dramatic]
    {swap_char()}
    Well, I'm just here to save the world.
    {swap_char()}
    What an egoist.
{force_char(NPC)} // No guarantee that the current character is the NPC after choice 1
- Say... what do you make of me? // Prompt 2
* [Flatter]
    {swap_char()}
    You're the most beautiful eel I've ever seen.
    {swap_char()}
    Hehe... and how many other eels have you seen?
    ~ choicespassed += 1
* [Honest]
    {swap_char()}
    You're an eel.
    {swap_char()}
    Well, yes.
* [Careful]
    {swap_char()}
    I'm not sure, but so far you seem nice!
    {swap_char()}
    What a plain answer.
{force_char(NPC)} // No guarantee that the current character is the NPC after choice 2
- Would a strong plesiosaur like yourself be able to keep me safe in the unsure times ahead? // Prompt 3
* [Gaslight]
    {swap_char()}
    What unsure times?
    {swap_char()}
    You can't fool me.
* [Honest]
    {swap_char()}
    I'm not really into taking preventative measures. I could potentially avenge you if something happened, though.
    {swap_char()}
    I'm not really into being avenged.
* [Tough]
   {swap_char()}
   I can easily protect you from any harm. I've got fins for days and a heart ready for stealing.
   {swap_char()}
   My, my, my... you're really something!
   ~ choicespassed += 1
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
    Please... take my number.
    ~ charm += choicespassed
    ~ enable_charbox = false // Disable the character box for this message
    {NPC} has been charmed by your flirt!
    Your charm has increased to {charm}!
- else:
    Swipe left.
    ~ enable_charbox = false
    {NPC} has left.
}
-> END
// Define some variables we will be using
VAR charm = 0 // The idea is to get the charm from the game stat (somehow)
CONST threshold1 = 5 // Threshold charm for passing if you passed only one choice
CONST threshold2 = 3 // The same, but for passing two choices
CONST NPC = "Flounder" // This is the character you are talking to.
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

I'm so confused. What is going on? // Prompt 1
* [Optimistic]
    {swap_char()}
    Everyone has returned to the Thames! It's great!
    {swap_char()}
    I didn't even notice that we left?
* [Confusing]
    {swap_char()}
    I thought you were supposed to help me understand?
    {swap_char()}
    W-was I?
* [Honest]
    {swap_char()}
    Well, I just got here. I'm not entirely sure. It looks like quite a few species have returned. Is that right?
    {swap_char()}
    Oh yeah! That is what happened, now that I think about it. We all came back since the water is cleaner!
    ~ choicespassed += 1
{force_char(NPC)} // No guarantee that the current character is the NPC after choice 1
Why can't I see you right now? // Prompt 2
* [Honest]
    {swap_char()}
    Both your eyes are on the same side of your head, so...
    {swap_char()}
    What? I never noticed...
* [Helpful]
    {swap_char()}
    Hm, I'll move so you can see me!
    {swap_char()}
    Oh thanks! I see you now!
    ~ choicespassed += 1
* [Gaslight]
    {swap_char()}
    You were never able to see anyone. What are you talking about? What's "seeing"?
    {swap_char()}
    Stop, I'm already so confused... what is happening?!
{force_char(NPC)} // No guarantee that the current character is the NPC after choice 2
Are things really okay right now? // Prompt 3
* [Simple]
    {swap_char()}
    Yeah, I think so.
    {swap_char()}
    Ok good.
    ~ choicespassed += 1
* [Realistic]
    {swap_char()}
    The Thames has just survived a major disaster, and is in fragile recovery.
    {swap_char()}
    Oh... fragile...
* [Mean]
   {swap_char()}
   No.
   {swap_char()}
   ...(cries)
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
    Thanks for helping me! I'm always so lost! I appreciate it.
    ~ charm += choicespassed
    ~ enable_charbox = false // Disable the character box for this message
    {NPC} has been charmed by your flirt!
    Your charm has increased to {charm}!
- else:
    I'm still so confused...
    ~ enable_charbox = false
    {NPC} has left.
}
-> END
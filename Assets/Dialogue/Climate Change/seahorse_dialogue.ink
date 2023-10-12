// Define some variables we will be using
VAR charm = 0 // The idea is to get the charm from the game stat (somehow)
CONST threshold1 = 5 // Threshold charm for passing if you passed only one choice
CONST threshold2 = 3 // The same, but for passing two choices
CONST NPC = "Seahorse" // This is the character you are talking to.
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

Woah, woah, woah. What kind of tiny creature are you supposed to be? No offense! // Prompt 1
* [Hype]
    {swap_char()}
    Yoooo, your gains are crazy!
    {swap_char()}
    Heck yeah!  It's fin day everyday!
    ~ choicespassed += 1
* [Honest]
    {swap_char()}
    My brethren, you are much more tiny than I.
    {swap_char()}
    Don't start with me, mate. You won't like what's coming. I'll let it slide this once.
* [Neutral]
    {swap_char()}
    Hi, I'm Tessie, a plesiosaur!
    {swap_char()}
    Hi! I am a seahorse, named after large land animals called horses - probably because I am so large!

{force_char(NPC)} // No guarantee that the current character is the NPC after choice 1
I excerise all the time, to keep my height up.  What's your favourite workout, mate?// Prompt 2
* [Lazy]
    {swap_char()}
    Oh, I don't exercise.  Swimming around and saving the day is enough to keep me fit!
    {swap_char()}
    You are going to die.
* [Buff]
    {swap_char()}
    All at once.
    {swap_char()}
    Heck yeah! That is it!
    ~ choicespassed += 1
* [Realistic]
    {swap_char()}
    Tail-presses!
    {swap_char()}
    I can do 1,000 of those right now.
{force_char(NPC)} // No guarantee that the current character is the NPC after choice 2
You know, if something happens to this river, I won't be able to keep fit.  Is there anything I can do to help? // Prompt 3
* [Corporate]
    {swap_char()}
    Reuse, Reduce, Recycle! Everyone do your bit! We are all a small part of the solution!
    {swap_char()}
    Who are you calling "small part", eh? You want to bring this outside?
* [Depressing]
    {swap_char()}
    No individual has that much influence.
    {swap_char()}
    With my thick fins, I can do anything.
* [Supportive]
   {swap_char()}
   There's a lot you can do! Maybe you can help me monitor the changes in your area?
   {swap_char()}
    Yes, mate! We can do this!
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
    Let's lift some shells together soon, mate!
    ~ charm += choicespassed
    ~ enable_charbox = false // Disable the character box for this message
    {NPC} has been charmed by your flirt!
    Your charm has increased to {charm}!
- else:
    Go to the gym and then try me, shrimp.
    ~ enable_charbox = false
    {NPC} has left.
}
-> END
// Define some variables we will be using
VAR charm = 0 // The idea is to get the charm from the game stat (somehow)
CONST threshold1 = 5 // Threshold charm for passing if you passed only one choice
CONST threshold2 = 3 // The same, but for passing two choices
CONST NPC = "Shark" // This is the character you are talking to.
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

Hello there, little morsel! // Prompt 1
* [Scared]
    {swap_char()}
    Ahh! A shark!
    {swap_char()}
    Hahaha! Relax! I'm just a dogfish.
    ~ choicespassed += 1
* [Brave]
    {swap_char()}
    I'm not afraid of you!
    {swap_char()}
    Ah, well, that's disappointing. I thought you'd jump or something...
* [Romantic]
    {swap_char()}
    Hey there, tiger. I'd let you eat me up.
    {swap_char()}
    uhh, listen, I was just joking, ok? You do you, but I'm taken already.
{force_char(NPC)} // No guarantee that the current character is the NPC after choice 1
- You've swum in this river for a while - so tell me.
What's the tastiest fish you've ever eaten? // Prompt 2
* [Pacifist]
    {swap_char()}
    Fish? I'm a vegetarian...
    {swap_char()}
    With those teeth? Don't kid yourself, haha.
* [Sophisticated]
    {swap_char()}
    Got a taste of jellied eel once, and it was fantastic.
    {swap_char()}
    I'm impressed!
    Londoners can't be throwing much of that overboard - you're one lucky dinosaur.
    ~ choicespassed += 1
* [Simplistic]
    {swap_char()}
    Nothing beats a battered cod!
    {swap_char()}
    Tasty, but a bit on the simplistic side, no?
    I like my fast food as much as any shark but something a bit more complex is more my style.
{force_char(NPC)} // No guarantee that the current character is the NPC after choice 2
- Fish around here are talking about climate change happening. What do you think? // Prompt 3
* [Scared]
    {swap_char()}
    To be honest - I'm scared. I feel so powerless to stop what's coming.
    {swap_char()}
    Well, you can do fear. I'm not worried.
    Sharks have been around a long, long time.
* [Dismissive]
    {swap_char()}
    Climate change? I think that's something for humans to worry about.
    {swap_char()}
    Damn, that's cold. Let's hope you can survive when the river gets a few degrees hotter.
* [Confident]
   {swap_char()}
   I think we can make a change. I wanna try to band together and do something about.
   {swap_char()}
   I can respect that, little shrimp. 
   Just don't wear yourself out. Some sharks would bite at the chance for a taste of plesiosaur.
   ~choicespassed += 1
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
    Well, swim on, shrimp. You're not getting eaten today.
    ~ charm += choicespassed
    ~ enable_charbox = false // Disable the character box for this message
    {NPC} has been charmed by your flirt!
    Your charm has increased to {charm}!
- else:
    You bore me, squirt. Now go, before I get hungry.
    ~ enable_charbox = false
    {NPC} has left.
}
-> END
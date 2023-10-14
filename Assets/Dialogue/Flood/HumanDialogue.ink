// Define some variables we will be using
VAR charm = 0 // The idea is to get the charm from the game stat (somehow)
CONST threshold1 = 5 // Threshold charm for passing if you passed only one choice
CONST threshold2 = 3 // The same, but for passing two choices
CONST NPC = "Human" // This is the character you are talking to.
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

Gluuuug! Glug! \(AAAAAAAAAAA! I'm gonna drown!\) // Prompt 1
* [Soothe]
    {swap_char()}
    Hey, hey, hey. It's ok. I'm not sure there's anything we can do to save you, but if you panic that will make things worse.
    {swap_char()}
    Glug... Glug? \(You mean... this is really the end?\)
    ~ choicespassed += 1
* [Reassure]
    {swap_char()}
    Listen, listen, we'll rescue you, ok? Just stay calm.
    {swap_char()}
    Glug? Glug! \(How? The river is raging too fast!\)
* [Condemn]
    {swap_char()}
    A human asking me for help? Do you remember how humans ruined this river during the Great Stink?
    {swap_char()}
    Glug! Glug glug... \(I didn't do anything! I just work in the civil service...\)
{force_char(NPC)} // No guarantee that the current character is the NPC after choice 1
- Glug glug? (What about my family?) // Prompt 2
* [Truthful]
    {swap_char()}
    I think you're going to have to face that you probably won't see them again. 
    {swap_char()}
    Gl-glug... Glug. \(I- ok... At least I lived a good life with them.\)
    ~ choicespassed += 1
* [Optimistic]
    {swap_char()}
    It's ok, you'll see them soon! Think about home and you'll be there in no time!
    {swap_char()}
    Glug! Glug! \(It's too hard to think! All I can hear is the water rushing around me!\)
* [Pessimistic]
    {swap_char()}
    They'll have to carry on without you.
    {swap_char()}
    Glug! Glug... \(No! My poor wife will miss me so much...\)
{force_char(NPC)} // No guarantee that the current character is the NPC after choice 2
- Glug. Glug... \(I think I'm fading. I can't stay under much longer...\) // Prompt 3
* [Calm]
    {swap_char()}
    This is it. Just relax and it'll make it easier when you go...
    {swap_char()}
    Glug. \(This really is it, huh. Alright, I'll be calm.\)
    ~ choicespassed += 1
* [Practical]
    {swap_char()}
    Maybe you can try grab onto a tree branch or something?!
    {swap_char()}
    Glug. Glug... (It's too late. My strength is gone...)
* [Sad]
    {swap_char()}
    No! Please don't go! Just hold your breath a little longer and you'll make it!
    {swap_char()}
    Glug... (I don't think I can last...) 
   
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
    Glug! Glug... (Thank you Tessie! I'm not as scared anymore...)
    ~ charm += choicespassed
    ~ enable_charbox = false // Disable the character box for this message
    {NPC} has been charmed by your flirt!
    Your charm has increased to {charm}!
- else:
    Glug! \(I don't wanna die!\)
    ~ enable_charbox = false
    {NPC} has left.
}
-> END
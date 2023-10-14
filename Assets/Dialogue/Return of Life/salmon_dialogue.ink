// Define some variables we will be using
VAR charm = 0 // The idea is to get the charm from the game stat (somehow)
CONST threshold1 = 5 // Threshold charm for passing if you passed only one choice
CONST threshold2 = 3 // The same, but for passing two choices
CONST NPC = "Salmon" // This is the character you are talking to.
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

Hello! I'm a salmon! Everyone loves me! They even make special treats for me on land, called sushi! // Prompt 1
* [Teasing]
    {swap_char()}
    You like sushi? That's so niche!
    {swap_char()}
    I know, I know! I'm lucky so many people want to be my friend!
    ~ choicespassed += 1
* [Honest]
    {swap_char()}
    They will eat you.
    {swap_char()}
    W-what? Eat me? Why would someone do such a thing?
* [Gentle]
    {swap_char()}
    Um, I think that the sushi you refer to might not be "for" you...
    {swap_char()}
    Huh? What do you mean? Why wouldn't it be?
{force_char(NPC)} // No guarantee that the current character is the NPC after choice 1
- The humans seem to love it now that I'm back! Although a few of my brothers have been mysteriously disappearing lately. // Prompt 2
* [Honest]
    {swap_char()}
    They were eaten by humans.
    {swap_char()}
    N-no! Stop lying! That's a terrible thing to say!
* [Teasing]
    {swap_char()}
    I'm sure they just went to another river up North to swim around with more space.
    {swap_char()}
    Yeah, that's what I think, too!
    ~ choicespassed += 1
* [Gaslight]
    {swap_char()}
    No they didn't. You're crazy.
    {swap_char()}
    Oh, you're probably right.
{force_char(NPC)} // No guarantee that the current character is the NPC after choice 2
- I'm so happy to be back in the Thames.  I hope I never have to leave again! // Prompt 3
* [Rude]
    {swap_char()}
    Well, soon you'll have no choice. Someone is going to eat you.
    {swap_char()}
    Is that a joke, haha? I think?
* [Kind]
   {swap_char()}
   I hope so, too, friend!
   {swap_char()}
   Thames forever!
* [Hungry]
    {swap_char()}
    I'm glad you're here too! You should come over for dinner sometime, we can have sushi!
    {swap_char()}
    Sounds great! Yum!
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
    I can't wait for our sushi night! I'm so excited to try sushi!
    ~ charm += choicespassed
    ~ enable_charbox = false // Disable the character box for this message
    {NPC} has been charmed by your flirt!
    Your charm has increased to {charm}!
- else:
    Well, I better be off now. (You're kind of scary)
    ~ enable_charbox = false
    {NPC} has left.
}
-> END
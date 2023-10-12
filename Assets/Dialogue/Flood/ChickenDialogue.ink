// Define some variables we will be using
VAR charm = 0 // The idea is to get the charm from the game stat (somehow)
CONST threshold1 = 5 // Threshold charm for passing if you passed only one choice
CONST threshold2 = 3 // The same, but for passing two choices
CONST NPC = "Chicken" // This is the character you are talking to.
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
== scared ==
{force_char(NPC)}
Why'd you have to go scare me like that?!
You suck!
~ enable_charbox = false
{NPC} ran away.
-> END

== main ==

Aaa! A creature! // Prompt 1
* [Scare]
    {swap_char()}
    Boo! Did I scare ya?
    {swap_char()}
    AAAAAAAAAAAAA!
    -> scared
* [Laugh]
    {swap_char()}
    Hahaha! A creature, that's funny. I'm Tessie, and I'm a plesiosaur
    {swap_char()}
    That sounds scary! Never heard've a Plesiosaur before, I haven't!
* [Soothe]
    {swap_char()}
    Hey, it's ok, I'm not gonna hurt ya, I'm friendly! 
    My name's Tessie!
    {swap_char()}
    I'm trusting you not to scare me, Tessie. 
    This storm has frightened me right up!
    ~ choicespassed += 1
{force_char(NPC)} // No guarantee that the current character is the NPC after choice 1
- You have such big teeth! Please don't put them anywhere near me! // Prompt 2
* [Reassure]
    {swap_char()}
    Don't worry, I'm vegetarian!
    {swap_char()}
    Well, alrighty then. This storm has ruffled my feathers, it has!
* [Show teeth]
    {swap_char()}
    Aww, but I've heard great things about chicken wings!
    {swap_char()}
    AAAAAAAAAAAAAA!
    -> scared
* [Protect]
    {swap_char()}
    I'll make sure no one can hurt you while you're here in the river, ok?
    {swap_char()}
    Well, that's mighty reassuring. Thank you, friend.
    ~ choicespassed += 1
{force_char(NPC)} // No guarantee that the current character is the NPC after choice 2
- How d'you think we'll get outta this flood? // Prompt 3
* [Hunger]
    {swap_char()}
    You'll probably get out of it by being my dinner!
    {swap_char()}
    AAAAAAAAAAAA!
    -> scared
* [Practical]
    {swap_char()}
    Once the storm is over, the flood will pass soon after.
    {swap_char()}
    If you say so...
* [Reassuring]
   {swap_char()}
   It'll be over soon, don't worry.
   {swap_char()}
   That's good to hear, thank you.
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
    I'm feeling a lot better after talking to you, friend. Thank you.
    ~ charm += choicespassed
    ~ enable_charbox = false // Disable the character box for this message
    {NPC} has been charmed by your flirt!
    Your charm has increased to {charm}!
- else:
    I'm still feeling all ruffled. See ya!
    ~ enable_charbox = false
    {NPC} has left.
}
-> END
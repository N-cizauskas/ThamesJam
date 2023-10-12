// Define some variables we will be using
VAR charm = 0 // The idea is to get the charm from the game stat (somehow)
CONST threshold1 = 5 // Threshold charm for passing if you passed only one choice
CONST threshold2 = 3 // The same, but for passing two choices
CONST NPC = "Dolphin" // This is the character you are talking to.
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

Why hello there... What brings a rare specimen such as yourself to these parts? // Prompt 1
* [Casual]
    {swap_char()}
    Vibes
    {swap_char()}
    Pardon?
* [Mysterious]
    {swap_char()}
    I am but a wanderer, set on a seemingly endless mission.
    {swap_char()}
    Hm! Quite an interesting conversation partner I've encountered!
    ~ choicespassed += 1
* [Enthusiastic]
    {swap_char()}
    I'm Tessie, a plesiosaur, and I want to save the Thames!
    {swap_char()}
    Quite the open book, you are.
{force_char(NPC)} // No guarantee that the current character is the NPC after choice 1
- Perhaps you can help me with this riddle: what is one, but also two, is always awake, but always asleep? // Prompt 2
* [Low-effort]
    Me.
    {swap_char()}
    Not quite.
* [Flattering]
    Your brain.
    {swap_char()}
    Well, well. You seem to know your stuff.
    ~ choicespassed += 1
* [Confused]
    Uh, what? Sorry... what?
    {swap_char()}
    Ugh... Associating wtih the ignorant brings me nothing.
{force_char(NPC)} // No guarantee that the current character is the NPC after choice 2
- Things seem to be nice here, but I've noticed things. The winters do not get as cold as they once did.  The water tastes
more and more like acid.  Do you think something strange is afoot? // Prompt 3
* [Optimistic]
   If things seem okay, then they probably are okay! I wouldn't worry too much.
   {swap_char()}
    It is indeed easier to be a fool.
* [Nihilistic]
   I've sensed that as well, but I fear there's nothing we can do.  Why should we anyway?
   {swap_char()}
    Ignorance is bless, I suppose...
* [Curious]
   I am concerned as well. I can't quite figure out what's happening here.
   {swap_char()}
    Well, I am happy to hear someone else is thinking about it.  I was perplexed as to why I was the only one noticing these matters.
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
    You are quite the curious speciem indeed. I am blessed to have encountered you.
    ~ charm += choicespassed
    ~ enable_charbox = false // Disable the character box for this message
    {NPC} has been charmed by your flirt!
    Your charm has increased to {charm}!
- else:
    I would rather converse with a more sophisticated species now.
    ~ enable_charbox = false
    {NPC} has left.
}
-> END
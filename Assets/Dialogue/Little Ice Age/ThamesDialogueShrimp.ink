// Define some variables we will be using
VAR charm = 0 // The idea is to get the charm from the game stat (somehow)
VAR threshold1 = 0 // Threshold charm for passing if you passed only one choice
VAR threshold2 = 0 // The same, but for passing two choices
// We will try to set both in EnemyData
CONST NPC = "Shrimp" // This is the character you are talking to.
VAR current_char = NPC // This variable tracks the currently talking character. It will be passed to the "current talker" box every time dialogue is continued
// Let's flag the number of times we make the correct choice
VAR choicespassed = 0
// VAR charmgain = 0 // Tracks the amount of charm gained in the flirt
// And this one tells us if the flirt has been passed
VAR flirtpassed = false
// This variable determines whether the character box is displayed
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
H-Hi. Don’t think I’ve seen you around here before.
* [Flattered]
    {swap_char()}
    Why thank you! I'm kinda new around here.
    {swap_char()}
    Hopefully the Thames is treating you well - I love it here!
    ~ choicespassed += 1 // Choice passed
* [Confident]
    {swap_char()}
    Yeah, I’m a plesiosaur. Not many of us around nowadays.
    {swap_char()}
    I’ve never heard of a plesiosaur - that’s so cool!
    ~ choicespassed += 1 // Choice passed
* [Joking]
    {swap_char()}
    I’m shrimply here to have a good time!
    {swap_char()}
   Well I’ve certainly never heard THAT one before…
- S-so... What brings you here? // Yes, please do
* [Honest]
    {swap_char()}
    I just suddenly woke up here! 
    {swap_char()}
    Shouldn't you be freaking out right now?!
* [Casual]
    {swap_char()}
    I'm not really sure yet! For now, I'm just trying to figure out what's going on.
    {swap_char()}
    Oh, me too!
    ~ choicespassed += 1 // Choice passed
* [Aggressive]
    {swap_char()}
    I don't know, what brings anyone anywhere?
    {swap_char()}
    Eek! Sorry for asking!
{force_char(NPC)} // No guarantee that the current character is the NPC after choice 2
- All this ice in the river is so strange. I wonder what’s causing it?
* [Reassuring]
    {swap_char()}
    I’m not so sure, but I’ll get to the bottom of it soon.
    {swap_char()}
    I’m glad someone’s on the case - I feel better knowing that someone is doing something about it.
    ~ choicespassed += 1 // Choice passed
* [Cautionary]
    {swap_char()}
    I’m worried too - we should probably be careful.
    {swap_char()}
    Careful? I feel like I’m about to have a panic attack!
* [Optimistic]
    {swap_char()}
    It’ll blow over in no time - nothing to worry about!
    {swap_char()}
    Seems a bit too serious to just wave away to me…
{force_char(NPC)}
- /* Flirt decision here (the hyphen acts as a gather - please don't remove)
I'll assume that passing all three choices is an automatic success,
failing all three choices is an automatic failure,
and ending up in between will leave your chances of success to your charm stat.
*/
{ 
- choicespassed == 3:
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
    I'll see you around some time, ok?
    /* We can add charm proportional to how many choices we passed.
    Here we assume that every correct choice gains you 1 charm.
    If you would like to vary the amount of charm gained from each correct choice,
    you can declare a separate "charm gain" variable and increment it
    after every correct choice - I have commented out such a variable
    */
    ~ charm += choicespassed
    ~ enable_charbox = false // Disable the character box for this message
    {NPC} has been charmed by your flirt!
    Your charm has increased to {charm}!
- else:
    I think I'm gonna swim very far away.
    ~ enable_charbox = false
    {NPC} has left.
}
-> END
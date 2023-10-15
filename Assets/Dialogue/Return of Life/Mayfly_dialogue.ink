// Define some variables we will be using
VAR charm = 0 // The idea is to get the charm from the game stat (somehow)
VAR threshold1 = 0 // Threshold charm for passing if you passed only one choice
VAR threshold2 = 0 // The same, but for passing two choices
CONST NPC = "Mayfly" // This is the character you are talking to.
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

What is up, broski! // Prompt 1
* [Chill]
    {swap_char()}
    Vibes, man!
    {swap_char()}
    Ayyyy! Let's go! The vibes!
    ~ choicespassed += 1
* [Sarcastic]
    {swap_char()}
    The sky.
    {swap_char()}
    Chill, broski.
* [Emotional]
    {swap_char()}
    The average global temperature...
    {swap_char()}
    ... You're ruining the vibe.
{force_char(NPC)} // No guarantee that the current character is the NPC after choice 1
- I am just having such a good time right now. Literally nothing could stop me from having a good time right now. You feel? // Prompt 2
* [Relatable]
    {swap_char()}
    I feel you so much, broski.
    {swap_char()}
    I know, broski. We all feel it. That's a vibe.
* [Emotional]
    {swap_char()}
    Climate change could stop you from having a good time.
    {swap_char()}
    Yeah, I guess, but that's not really what I want to think about right now, Broski.
* [Energetic]
    {swap_char()}
    Yessss, let's get this party started! Turn up the music!
    {swap_char()}
    Yeah, now we're talking! Let's get moving!
    ~ choicespassed += 1
{force_char(NPC)} // No guarantee that the current character is the NPC after choice 2
- I'm kinda worried something is vibe checking me lately. You feel? // Prompt 3
* [Partying]
   {swap_char()}
    Can't hear you, broski. Music is too loud!
    {swap_char()}
    Nevermind, Broski! This beat is sick!
    ~ choicespassed += 1
* [Serious]
    {swap_char()}
    Yeah, I've been worrying about that, too, lately...
    {swap_char()}
    I don't want to think this deeply.
* [Dancing]
   {swap_char()}
   ... (dancing)
   {swap_char()}
   ...Broski? You good?
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
    There's a party round my place later tonight if you're down.
    ~ charm += choicespassed
    ~ enable_charbox = false // Disable the character box for this message
    {NPC} has been charmed by your flirt!
    Your charm has increased to {charm}!
- else:
    Bad vibes.
    ~ enable_charbox = false
    {NPC} has left.
}
-> END
// Define some variables we will be using
VAR charm = 0 // The idea is to get the charm from the game stat (somehow)
CONST threshold1 = 5 // Threshold charm for passing if you passed only one choice
CONST threshold2 = 3 // The same, but for passing two choices
CONST NPC = "Dirty Father Thames" // This is the character you are talking to.
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
{force_char("Tessie")}
So you're the one resposible for all this mess, I assume?
You shouldn't be here. You destroyed the river!
{swap_char()}
It's a fish-eat-fish world. I just happened to be the biggest fish.
Humans are so very intelligent. If only fish had been half as intelligent, you wouldn't've died out so easily.
{swap_char()}
Humans should be using their intelligence to protect to river!
It's so dirty that even humans are getting sick from it!
{swap_char()}
Anyone worthwhile can afford to live far enough away from the river that it doesn't matter.
It's only the poor being affected, really.
Plus, big companiesd thrive off of using the river as a disposal site.
That boosts the economy, so it's really better for everyone!
{swap_char()}
Don't you think everyone deserves to live somewhere with clean water?
{swap_char()}
That's a right that needs to be earned!
{swap_char()}
...
I disagree.
{force_char(NPC)}
The river is better this way! Humans are smart enough to know what's right and what's wrong. // Prompt 1
* ["Look around you."]
    {swap_char()}
    Better? How can it be better?
    Look around you. This place is completely barren.
    The river isn't dying, it's dead.
    

* ["That's not true"]
    Dialogue 1b
* ["Says who?"]
    Dialogue 1c
{force_char(NPC)} // No guarantee that the current character is the NPC after choice 1
- Insert dialogue to prompt choice 2 here // Prompt 2
* [Choice 2a]
    Dialogue 2a
* [Choice 2b]
    Dialogue 2b
* [Choice 2c]
    Dialogue 2c
{force_char(NPC)} // No guarantee that the current character is the NPC after choice 2
- Insert dialogue to prompt choice 3 here // Prompt 3
* [Choice 3a]
    Dialogue 3a
* [Choice 3b]
    Dialogue 3b
* [Choice 3c]
   Dialogue 3c
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
    Flirt pass dialogue here
    ~ charm += choicespassed
    ~ enable_charbox = false // Disable the character box for this message
    {NPC} has been charmed by your flirt!
    Your charm has increased to {charm}!
- else:
    Flirt failure dialogue here
    ~ enable_charbox = false
    {NPC} has left.
}
-> END
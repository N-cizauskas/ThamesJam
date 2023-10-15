// Define some variables we will be using
VAR charm = 0 // The idea is to get the charm from the game stat (somehow)
VAR threshold1 = 0
VAR threshold2 = 0
/* I don't think it's used in cutscene dialogues (if we are implementing that in VN),
but I think it's worth leaving in so as to not break the dialogue manager script
*/
CONST NPC = "The Politicians" // This is the character you are talking to.
VAR current_char = NPC // This variable tracks the currently talking character. It will be passed to the "current talker" box every time dialogue is continued
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
/* We are assuming that NPC starts the dialogue.
If Tessie is to start the dialogue, call force_char("Tessie")
by surrounding that function name with curly brackets.

Call swap_char() to switch the character in the character box between Tessie and the NPC
You may do this in between lines of dialogue.
For an example of applying this see the Shrimp script.

For a correct option (I assume bolded in the script),
add the following line at any point after the bullet point following the corresponding choice,
but before the bullet point for the next choice (or the hyphen that "gathers").
~ choicespassed += 1

For a particularly endearing choice, you could increase the variable by 2 (or more).

If you want to penalize a player harshly for making a bad choice,
you can manipulate the choicespassed variable to your liking.
Maybe subtract 1 from it. Or even set it to zero or negative (for an immediate failure). Your call.
*/
{force_char("Tessie")}
You don’t have the river’s best interests in mind.  You don’t even believe in what the fish are worried about.
{swap_char()}
Obviously not.  We have bigger concerns than some silly river.  
Besides, the climate always changes.  That’s just part of life.
{swap_char()}
But it will affect life as we know it - we need to prepare and make sure we are doing our best to prevent things from getting worse.
{swap_char()}
I guess.  We will be fine though, regardless, so why should we care?
{swap_char()}
Just go away, I’m going to register to vote just to spite you.
{swap_char()}
Fish can’t vote, silly.
{swap_char()}
Yeah, otherwise you wouldn’t be in office.  Now go!
~ enable_charbox = false
The Politicians have retreated!
-> END
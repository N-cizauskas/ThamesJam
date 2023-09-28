// Define some variables we will be using
VAR charm = 0 // The idea is to get the charm from the game stat (somehow)
/* I don't think it's used in cutscene dialogues (if we are implementing that in VN),
but I think it's worth leaving in so as to not break the dialogue manager script
*/
CONST NPC = "Iceberg" // This is the character you are talking to.
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
Why are you doing this to the Thames?
Can't you see the life inside the river is suffering from this drastic change?
{swap_char()}
So what? We all suffer.
I used to be a glacier a long time ago.
But orbital changes, volcanic activity, ocean currents... all these things made me this way.
Humans build bridges, preventing my travel to the ocean.
Why should I care about others after nobody has ever cared about me?
{swap_char()}
Just because you are suffering doesn't mean you should make other suffer, too.
{swap_char()}
You and I are alike.
We both don't belong here. Your species should be long extinct, and I should be drifting in the northernmost ocean.
You can't tell me to leave without exulting yourself, too.
{swap_char()}
I may not belong here, but I respect the Thames and everyone living inside of it.
// Transition to the flirt/fight scene
-> END
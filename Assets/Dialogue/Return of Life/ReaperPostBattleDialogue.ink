// Define some variables we will be using
VAR charm = 0 // The idea is to get the charm from the game stat (somehow)
/* I don't think it's used in cutscene dialogues (if we are implementing that in VN),
but I think it's worth leaving in so as to not break the dialogue manager script
*/
CONST NPC = "Dirty Father Thames" // This is the character you are talking to.
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
{force_char(NPC)}
YOU MAY HAVE BEATEN ME THIS TIME, TESSIE.
BUT YOU CANNOT EVADE ME FOREVER.
DEATH AND EXTINCTION WILL BE THERE ONE DAY.
{swap_char()}
But that day is not today.
{swap_char()}
...
YOU WOULD BE A GREAT REAPER.
{swap_char()}
Get out of here, scum.
// The "walking to the ocean" I assume can be animated?
-> END
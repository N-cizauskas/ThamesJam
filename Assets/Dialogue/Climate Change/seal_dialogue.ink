// Define some variables we will be using
VAR charm = 0 // The idea is to get the charm from the game stat (somehow)
VAR threshold1 = 0 // Threshold charm for passing if you passed only one choice
VAR threshold2 = 0 // The same, but for passing two choices
CONST NPC = "Seal" // This is the character you are talking to.
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

Hey there! I'm Seal! How're you doin' today? // Prompt 1
* [Optimistic]
    {swap_char()}
    Heya! I'm Tessie. I'm feeling good about life!
    {swap_char()}
    Well, that's lovely to hear!
    ~ choicespassed += 1
* [Pessimistic]
    {swap_char()}
    Meh. Just doing my usual, to be honest.
    {swap_char()}
    Now, don't be all blue like that...
* [Neutral]
    {swap_char()}
    I'm not too bad, thanks.
    {swap_char()}
    W-well, that's good.
{force_char(NPC)} // No guarantee that the current character is the NPC after choice 1
- Would you be friends with me if I were a worm? // Prompt 2
* [Practical]
    {swap_char()}
    Well, you're not a worm. You're a seal.
    {swap_char()}
    So you wouldn't?! Now I don't know if I can trust you...
* [Pleasing]
    {swap_char()}
    You'd still be you, so I think we could still be friends.
    {swap_char()}
    Oh, I'm so glad I can trust you!
    ~ choicespassed += 1
* [Truthful]
    {swap_char()}
    I've met plenty of wormly creatures recently. Some I liked, and some I didn't.
    {swap_char()}
    But what if it was me? Would it be different then?!
{force_char(NPC)} // No guarantee that the current character is the NPC after choice 2
- This climate change stuff has gotten me all in a hot bother. D'you think everything will be ok? // Prompt 3
* [Doubtful]
    {swap_char()}
    If I'm being honest: no. 
    It's hard to see how we could get out of this. 
    Things have already changed so much, we might be too late already.
    {swap_char()}
    Oh, that's awful. How will we make it?
* [Balanced]
    {swap_char()}
    I'm not sure. It could all be fine, but it requires that humans do something about it.
    And at the moment, I don't believe they will.
    {swap_char()}
    Gosh dang those humans! Why do they have so much power over nature?
* [Hopeful]
    {swap_char()}
    I'm sure that, if humans are willing to make the change, they'll figure out how to solve it.
    I'm worried, but I believe in them.
    {swap_char()}
    Well, if you believe, then so do I!
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
    Well, that was a lovely conversation! I hope I get to see you again!
    ~ charm += choicespassed
    ~ enable_charbox = false // Disable the character box for this message
    {NPC} has been charmed by your flirt!
    Your charm has increased to {charm}!
- else:
    Well, I think I gotta head. See you.
    ~ enable_charbox = false
    {NPC} has left.
}
-> END
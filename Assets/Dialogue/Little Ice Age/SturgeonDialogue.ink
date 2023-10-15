// Define some variables we will be using
VAR charm = 0 // The idea is to get the charm from the game stat (somehow)
VAR threshold1 = 0 // Threshold charm for passing if you passed only one choice
VAR threshold2 = 0 // The same, but for passing two choices
CONST NPC = "Sturgeon" // This is the character you are talking to.
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

Good day! To whom do I have the pleasure of speaking? // Prompt 1
* [Enthusiastic]
    {swap_char()}
    Hi there! The name’s Tessie!
    {swap_char()}
    It seems we shall be foregoing pleasantries.
* [Quirky]
    {swap_char()}
    Hiya! I’m Tessie the plesi- (osaur)!
    {swap_char()}
    ...quite the unpleasant demeanour you have.
* [Polite]
    {swap_char()}
    Nice to meet you. I’m Tessie. And you are?
    {swap_char()}
    I am Sturgeon - the king’s fish, don’t you know?
    ~ choicespassed += 1
{force_char(NPC)} // No guarantee that the current character is the NPC after choice 1
- I fancy a spot of afternoon tea, I think. What about you? // Prompt 2
* [Wishful]
    {swap_char()}
    Ah, that sounds lovely. May I join you?
    {swap_char()}
    Sorry, chum. You seem pleasant enough but as the king's fish I simply don't mingle with commoners.
* [Curious]
    {swap_char()}
    I think I shall have a wonder in your great river.
    {swap_char()}
    Ah, yes. A fine idea for such a crisp day.
    Just take care not to disturb the bottom feeders.
    ~ choicespassed += 1
* [Jealous]
    {swap_char()}
    Ah, what I would give for a nice afternoon tea...
    {swap_char()}
    Hmph. Well, if you're not fit to be the king's fish you're not fit to eat like the king.
{force_char(NPC)} // No guarantee that the current character is the NPC after choice 2
- What a bothersome situation this ice has caused. // Prompt 3
* [Sarcasm]
    {swap_char()}
    Well, aren't you the king's fish? Can't you command someone to do something about it?
    {swap_char()}
    Your cheek doesn't slide past me easily.
* [Flattery]
    {swap_char()}
    Your highness, I shall deal with the problem promptly.
    {swap_char()}
    Simply splendid. You shall be heralded as a knight of the realm, no doubt.
    ~ choicespassed += 1
* [Dismissal]
    {swap_char()}
    It's not so bad, I think. Nice to get a bit of frost in London.
    {swap_char()}
    It's been too frosty for too long, I dare say. I'd rather a little bit of respite.
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
    Well met.
    ~ charm += choicespassed
    ~ enable_charbox = false // Disable the character box for this message
    {NPC} has been charmed by your flirt!
    Your charm has increased to {charm}!
- else:
    Get out of my sight.
    ~ enable_charbox = false
    {NPC} has left.
}
-> END
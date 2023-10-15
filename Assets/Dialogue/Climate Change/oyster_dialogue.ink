// Define some variables we will be using
VAR charm = 0 // The idea is to get the charm from the game stat (somehow)
VAR threshold1 = 0 // Threshold charm for passing if you passed only one choice
VAR threshold2 = 0 // The same, but for passing two choices
CONST NPC = "Oyster" // This is the character you are talking to.
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

Hmmmm. Hello there. // Prompt 1
* [Passionate]
    {swap_char()}
    Hiya! I'm Tessie, what's your name?
    {swap_char()}
    Calm yourself, child. Let life flow over you...
    Breathe in...
    Breathe out...
    ...
    I am Oyster.
* [Reserved]
    {swap_char()}
    Hi there. I'm Tessie.
    {swap_char()}
    And I am Oyster. 
    It is a pleasure to meet you, for I sense your energies are at peace.
    ~ choicespassed += 1
* [Cautious]
    {swap_char()}
    Uhh, hi?
    {swap_char()}
    Hmmm. I sense a misalignment in your energies. 
    What are you afraid of? I pose no threat to you.
{force_char(NPC)} // No guarantee that the current character is the NPC after choice 1
- What strategies do you use to dismiss your bad energy? // Prompt 2
* [Exercise]
    {swap_char()}
    Usually I try and go for a really fast swim to work myself out of the issue.
    {swap_char()}
    Hmm. I'd be inclined to think that you risk introducing more bad energy by doing that.
* [Relaxation]
    {swap_char()}
    I try and relax by finding a warm bit of river and trying to take care of myself.
    {swap_char()}
    A valiant effort, but unfortunately that strategy is born of a cliché!
    It's less effective than one might imagine...
* [Passive]
    {swap_char()}
    I don't really have anything that I do. I just try to live my life and take what comes.
    {swap_char()}
    My, how wise! Perhaps it is you who is the teacher, and I the student...
    ~ choicespassed += 1
{force_char(NPC)} // No guarantee that the current character is the NPC after choice 2
- 
My child, the river gets warmer year after year. // Prompt 3
How will you control your energy during this time of turbulence?
* [Brave]
    {swap_char()}
    I'll focus my energy on defeating those behind the problem and fixing everything!
    I've done it before, and I can do it again!
    {swap_char()}
    Hmm. One cannot solve every problem on their own. 
    The world is bigger than one can even comprehend.
    It seems you still have much to learn.
* [Resigned]
    {swap_char()}
    I'm not sure what I can do. I'll probably focus on trying to find peace on my own.
    {swap_char()}
    Hmm. Things may be bleak, that does not mean one should become defeated so easily.
    It seems you still have much to learn.
* [Supporting]
   {swap_char()}
   I think I'll try to make peace with those around me, and help anyone who needs it.
   {swap_char()}
   Very good, very good. It is through togetherness that we find true peace.
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
    Your energies are an inspiration to be around, my friend. Good luck.
    ~ charm += choicespassed
    ~ enable_charbox = false // Disable the character box for this message
    {NPC} has been charmed by your flirt!
    Your charm has increased to {charm}!
- else:
    Your dark energy swirls in a cloud around me.
    This worries me greatly.
    I must hurry on.
    ~ enable_charbox = false
    {NPC} has left.
}
-> END
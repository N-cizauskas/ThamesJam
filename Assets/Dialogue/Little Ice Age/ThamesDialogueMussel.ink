// Define some variables we will be using
VAR charm = 0 // The idea is to get the charm from the game stat (somehow)
VAR threshold1 = 0 // Threshold charm for passing if you passed only one choice
VAR threshold2 = 0 // The same, but for passing two choices
CONST NPC = "Mussel" // This is the character you are talking to.
VAR current_char = NPC // This variable tracks the currently talking character. It will be passed to the "current talker" box every time dialogue is continued
// Let's flag the number of times we make the correct choice
VAR choicespassed = 0
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
*/
Hi. // Please do
* [Awkwardly reply]
    {swap_char()}
    Hey there.
    {swap_char()}
    ... hi.
* [Be welcoming]
    {swap_char()}
    Hey, I'm Tessie. How're you doing today?
    {swap_char()}
    I'm not doing too bad. Thanks for asking.
    ~ choicespassed += 1
* [Act curious]
    {swap_char()}
    Well, what'd we have here? You're a mussel, right?
    {swap_char()}
    Well, obviously...
{force_char(NPC)} // No guarantee that the current character is the NPC after choice 1
- What are you most proud about yourself? // Yes, please do
* [Crack a joke]
    {swap_char()}
    I'd probaby say my muscles.
    You know, like mussels, because you're a mussel...
    {swap_char()}
    Not funny, dude.
* [Show emotions]
    {swap_char()}
    I like to think that I can share how I'm feeling.
    Having access to my emotions helps me figure out how to improve myself.
    {swap_char()}
    You know, I should try that myself some time.
    ~ choicespassed += 1
* ["I'm unique!"]
    {swap_char()}
    Well, I think I'm the last of my species.
    Don't know if there have been many plesiosaurs about recently.
    {swap_char()}
    It's nice that some of us get to be special, I guess.
{force_char(NPC)} // No guarantee that the current character is the NPC after choice 2
- What'd you think about all this ice about, eh? // Absolutely, please do
* [Be truthful]
    {swap_char()}
    To be honest, it's scary to think that the river is so frozen over.
    But I'm gonna try to fix it.
    {swap_char()}
    You know, it's nice to hear someone admit it - this is scary.
    I think we'll get through it.
    ~ choicespassed += 1
* [Act brave]
    {swap_char()}
    I'm not worried. I know that it'll be fixed.
    {swap_char()}
    Well if only we could all be as noble as you.
* [Act unconcerned]
    {swap_char()}
    Oh, the ice? Barely even had to think about it.
    {swap_char()}
    Yeah, yeah, I'm sure you have, tough guy.
{force_char(NPC)} // The NPC will be having the final say
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
    Thanks for the chat. It's not often I get to open up.
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
    You know, I think it'd be best if you leave...
    ~ enable_charbox = false
    {NPC} has left.
}
-> END
// Define some variables we will be using
VAR charm = 0 // The idea is to get the charm from the game stat (somehow)
CONST threshold1 = 5 // Threshold charm for passing if you passed only one choice
CONST threshold2 = 3 // The same, but for passing two choices
CONST NPC = "Lamprey" // This is the character you are talking to.
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
You there!
You're not trying to impede on my territory, are you?// Please do
* ["No, absolutely not."]
    {swap_char()}
    Not at all!
    Just a visitor passing my way through.
    {swap_char()}
    Good. We wouldn't want any trouble, would we?
    ~ choicespassed += 1
* [Act proud]
    {swap_char()}
    Your territory?
    Why would I want any of that?
    {swap_char()}
    Watch your words, squirt.
* [Taunt them]
    {swap_char()}
    So what if I am?
    Don't think I could handle you?
    {swap_char()}
    You got guts to say that to me, kid.
    ~ choicespassed += 1
{force_char(NPC)} // No guarantee that the current character is the NPC after choice 1
- Insert dialogue to prompt choice 2 here // Yes, please do
* [Choice 2a]
    Dialogue 2a
* [Choice 2b]
    Dialogue 2b
* [Choice 2c]
    Dialogue 2c
{force_char(NPC)} // No guarantee that the current character is the NPC after choice 2
- All this ice everywhere is so frustrating! What's going on around here!? // Absolutely, please do
* [Try to explain]
    {swap_char()}
    Well, it's the little ice age...
    If we can get to the bottom of that, we can probably deal with the ice.
    {swap_char()}
    I don't want explanations, I want solutions!
* ["I'll handle this."]
    {swap_char()}
    Now that I'm about, you won't have to worry about it much longer.
    {swap_char()}
    I like your style. I'll hold you to that.
    ~ choicespassed += 1
* [Blame them]
    {swap_char()}
    You seem like the sorta fish that could handle it yourself if it's frustrating you so much.
    {swap_char()}
    Now just what are you trying to say about me?
    ~ choicespassed -= 1
    // Particularly incendiary choices could lose you flirt progress!
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
    Good luck out there, squirt.
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
    Get outta here before I turn you into dinosaur nuggets.
    // Do you want to add some consolation charm? Not sure if it makes sense to do so
    ~ enable_charbox = false
    {NPC} has left.
}
-> END
// Define some variables we will be using
VAR charm = 0 // The idea is to get the charm from the game stat (somehow)
VAR threshold1 = 5 // Threshold charm for passing if you passed only one choice
VAR threshold2 = 3 // The same, but for passing two choices
CONST NPC = "Cholera" // This is the character you are talking to.
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

For a particularly endearing choice, you could increase the variable by 2 (or more).

If you want to penalize a player harshly for making a bad choice,
you can manipulate the choicespassed variable to your liking.
Maybe subtract 1 from it. Or even set it to zero or negative (for an immediate failure). Your call.
*/
Well, well, well, didn't expect to see multi-cellular life down here! Hehehe... // Please do
* [Feign Ignorance]
    {swap_char()}
    What on earth - are you a bacterial colony?!
    {swap_char()}
    I'm cholera! Everyone knows cholera! How have you never heard of us?
* [Show Disgust]
    {swap_char()}
    Cholera - no surprise to see you here enjoying all this filth.
    {swap_char()}
    That's right. I'm the king of these brown waters! Hehehe...
    ~ choicespassed += 1
* [Act unimpressed]
    {swap_char()}
    I tend not to bother worrying about anything my immune system can handle.
    {swap_char()}
    We'll see about that in 12-60 hours! Hehehe...
{force_char(NPC)} // No guarantee that the current character is the NPC after choice 1
- What's your favourite symptom that I cause? // Yes, please do
* [Refuse to Answer]
    {swap_char()}
    I'm not answering that.
    {swap_char()}
    Don't be so boring! Enjoy the filth a little! Hehehe...
* [Moral Answer]
    {swap_char()}
    My favourite part of cholera is treating it with medicine and people recovering from it!
    {swap_char()}
    No need to be a little goodie two flippers! I'm just trying to have a little fun.
* [Play Along]
    {swap_char()}
    I'd probably say diarrhoea.
    {swap_char()}
    Ooh, that's a good one! I never thought I'd hear you say that! Hehehe... 
    ~ choicespassed += 1
{force_char(NPC)} // No guarantee that the current character is the NPC after choice 2
- Life has never been better for cholera in London. You better not do anything to stop us!// Absolutely, please do
* [Appease]
    {swap_char()}
    If you don't bother me, I won't bother you.
    {swap_char()}
    Deal.
* [Threaten]
    {swap_char()}
    I'm gonna save this river no matter what it takes!
    {swap_char()}
    Hehehe, I doubt one fish could even stop us anyway.
* [Encourage]
    {swap_char()}
    Sounds fine by me. Not like a plesiosaur like me can contract cholera anyway...
    {swap_char()}
    I like the sound of that! Hehehe...
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
    You know, you and I are gonna have a great relationship, mestinks. Hehehe...
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
    ~ enable_charbox = true // Special event for this chat because I think it'd be funny
    {force_char("Tessie")}
    (It doesn't seem right to be making friends with deadly bacteria...)
- else:
    Man, you stink. Not even I want to hang around you...
    // Do you want to add some consolation charm? Not sure if it makes sense to do so
    ~ enable_charbox = false
    {NPC} has left.
}
-> END
// Define some variables we will be using
VAR charm = 0 // The idea is to get the charm from the game stat (somehow)
VAR threshold1 = 0 // Threshold charm for passing if you passed only one choice
VAR threshold2 = 0 // The same, but for passing two choices
CONST NPC = "Trout" // This is the character you are talking to.
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
Hullo there.
* [Be quirky] // How do you even describe this halp
    {swap_char()}
    Hiyaa, I'm Tessie!! I'm a plesiosaur!
    {swap_char()}
    Well, nice to meet you Tessie.
    ~ choicespassed += 1
* [Be polite]
    {swap_char()}
    Hello. My name's Tessie.
    {swap_char()}
    And mine's Trout.
    ~ choicespassed += 1
* [Cautiously "Hi" back]
    {swap_char()}
    Hi.
    // The trout says nothing back for a while
    ~ enable_charbox = false
    The trout does not answer immediately.
    But eventually, it does find the courage to muster up another line.
    ~ enable_charbox = true
{force_char(NPC)} // No guarantee that the current character is the NPC after choice 1
- I like to swim in my spare time. How do you spend your evenings?
* ["Wait, but you're a fish?"]
    {swap_char()}
    Your hobby is swimming? Aren't you a fish?
    {swap_char()}
    No need to be judgemental. I just like to swim.
* ["I like doing things!"]
    {swap_char()}
    I like doing anything!
    Getting to know new folks, training to get myself stronger, exploring this river - probably more too!
    {swap_char()}
    Sounds exciting! Do come back and tell me how it's going!
    ~ choicespassed += 1
* ["Just chill."]
    {swap_char()}
    Ehh, nothing much - just this and that, you know?
    {swap_char()}
    Well you should find something that interests you, or some will think you're a bit of a trout.
{force_char(NPC)} // No guarantee that the current character is the NPC after choice 2
- This ice is quite annoying, you know.
* [Vow to remove it]
    {swap_char()}
    I'm looking forward to trying to get rid of it.
    It'll be a challenge, but what is fun without challenge?
    {swap_char()}
    What a fascinating outlook. I wish you the best.
    ~ choicespassed += 1
* ["It'll go away"]
    {swap_char()}
    It'll be gone soon enough - don't you worry.
    {swap_char()}
    And then it'll be back to the same old river again, I bet?
* ["It doesn't bother me."]
    {swap_char()}
    I think I've gotten used to it by now.
    It's not too much of a bother at least.
    {swap_char()}
    Maybe not for you, but it's interfering with my schedule!
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
    Well you are certainly an interesting creature. This was nice.
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
    Well, I think I shall head off.
    And I thought I was boring...
    // Do you want to add some consolation charm? Not sure if it makes sense to do so
    ~ enable_charbox = false
    {NPC} has left.
}
-> END
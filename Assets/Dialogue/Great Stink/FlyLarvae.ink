// Define some variables we will be using
VAR charm = 0 // The idea is to get the charm from the game stat (somehow)
VAR threshold1 = 0 // Threshold charm for passing if you passed only one choice
VAR threshold2 = 0 // The same, but for passing two choices
CONST NPC = "Fly Larva" // This is the character you are talking to.
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

Hello, you look interesting! Who are you? // Prompt 1
* [Short Answer]
    {swap_char()}
    I'm Tessie.
    {swap_char()}
    Is Tessie all you are? Or are you just being boring?
* [Longer Answer]
    {swap_char()}
    My name's Tessie. I'm a plesiosaur.
    {swap_char()}
    That's interesting! I'd love to know more about plesiosaurs!
    ~ choicespassed += 1
* [Answer With a Question]
    {swap_char()}
    Never mind me - who are you?
    {swap_char()}
    You can't answer a question with a question! That's boring!
{force_char(NPC)} // No guarantee that the current character is the NPC after choice 1
- What do you want to be when you grow up? // Prompt 2
* [Be Pedantic]
    {swap_char()}
    I think no matter what I want, I'll end up an adult plesiosaur.
    {swap_char()}
    I see you have no imagination whatsoever!
* [Be Aspirational]
    {swap_char()}
    I want to save this river, and its inhabitants, from anything making it dangerous!
    {swap_char()}
    Isn't that a bit cliché?
* [Be Absurd]
    {swap_char()}
    I've always wanted to become a beekeeper.
    {swap_char()}
    That's possibly the weirdest thing I've ever heard a fish say! 
    I think I want to grow up to be a fly.
    ~ choicespassed += 1
{force_char(NPC)} // No guarantee that the current character is the NPC after choice 2
- Do you think the Great Stink will stay forever? // Prompt 3
* [Be Defiant]
    {swap_char()}
    I don't think it will - it'll be over, soon, and that's because I'm going to try and stop it myself!
    {swap_char()}
    Well, I don't like the sound of that, but I'm glad that it's interesting!
    ~ choicespassed += 1
* [Be Indecisive]
    {swap_char()}
    I'm not really sure, but I hope not...
    {swap_char()}
    Couldn't you have said a more interesting answer than that?
* [Be Pessimistic]
    {swap_char()}
   It certainly seems that way at the moment - sometimes I doubt that one plesiosaur can change a whole river...
   {swap_char()}
   Well I love this dirty river, so I'm happy that nothing is changing!
   {swap_char()}
   Good for you.
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
    Thanks for such an interesting conversation! See ya later!
    ~ charm += choicespassed
    ~ enable_charbox = false // Disable the character box for this message
    {NPC} has been charmed by your flirt!
    Your charm has increased to {charm}!
- else:
    You're so boring! I'm gonna go do something else!
    ~ enable_charbox = false
    {NPC} has left.
}
-> END
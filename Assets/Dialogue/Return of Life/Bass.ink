// Define some variables we will be using
VAR charm = 0 // The idea is to get the charm from the game stat (somehow)
CONST threshold1 = 5 // Threshold charm for passing if you passed only one choice
CONST threshold2 = 3 // The same, but for passing two choices
CONST NPC = "Bass" // This is the character you are talking to.
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

Hey there. What kind of music do you like?// Prompt 1
* [Refined]
    {swap_char()}
    Classical, orchestral stuff, and opera.
    {swap_char()}
    Ok nerd.
* [Normie]
    {swap_char()}
    Just pop and top 100s.
    {swap_char()}
    Ok normie.
* [Hardcore]
    {swap_char()}
    Underground metalpipecore. The heavy stuff.
    {swap_char()}
    Wow, you're the real deal!
    ~ choicespassed += 1
{force_char(NPC)} // No guarantee that the current character is the NPC after choice 1
- What's your favourite instrument? // Prompt 2
* [Hardcore]
    {swap_char()}
    The metal pipe.
    {swap_char()}
    Guess it's got to be someone's favourite.
* [People-pleaser]
    {swap_char()}
    Bass.
    {swap_char()}
    Yes! (headbangs)
    ~ choicespassed += 1
* [Normie]
    {swap_char()}
    Piano.
    {swap_char()}
    Ok. I like bass.
{force_char(NPC)} // No guarantee that the current character is the NPC after choice 2
- I'm so glad I can be rocking here again. I sure hope nothing uncool happens. // Prompt 3
* [Cool]
   {swap_char()}
    Uncool things are so normie.
    {swap_char()}
    Exactly!
* [Serious]
    {swap_char()}
    I'm a bit worried, too. I hope nothing bad happens again.
    {swap_char()}
    You're not helping my worries much.
* [Guitar riff]
   {swap_char()}
   ... (guitar riff)
   {swap_char()}
   ... (headbangs)
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
    Come rock out with me sometime!
    ~ charm += choicespassed
    ~ enable_charbox = false // Disable the character box for this message
    {NPC} has been charmed by your flirt!
    Your charm has increased to {charm}!
- else:
    Go listen to three of my albums.
    ~ enable_charbox = false
    {NPC} has left.
}
-> END
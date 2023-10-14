// Define some variables we will be using
VAR battlebonus = 0 // This will track the bonus gained for the boss battle
CONST NPC = "Dirty Father Thames" // This is the character you are talking to.
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
{force_char("Tessie")}
So you're the one resposible for all this mess, I assume?
You shouldn't be here. You destroyed the river!
{swap_char()}
It's a fish-eat-fish world. I just happened to be the biggest fish.
Humans are so very intelligent. If only fish had been half as intelligent, you wouldn't've died out so easily.
{swap_char()}
Humans should be using their intelligence to protect to river!
It's so dirty that even humans are getting sick from it!
{swap_char()}
Anyone worthwhile can afford to live far enough away from the river that it doesn't matter.
It's only the poor being affected, really.
Plus, big companiesd thrive off of using the river as a disposal site.
That boosts the economy, so it's really better for everyone!
{swap_char()}
Don't you think everyone deserves to live somewhere with clean water?
{swap_char()}
That's a right that needs to be earned!
{swap_char()}
...
I disagree.
{force_char(NPC)}
The river is better this way! Humans are smart enough to know what's right and what's wrong. // Prompt 1
* ["Look around you."]
    {swap_char()}
    Better? How can it be better?
    Look around you. This place is completely barren.
    The river isn't dying, it's dead.
    {swap_char()}
    It's not like it really matters.
    What's a stinking river to humans?
    {swap_char()}
    ...
    I don't think you really believe that.
    {swap_char()}
    I-
    I-
    You be careful what you say.
    ~ choicespassed += 1 
* ["That's not true"]
    {swap_char()}
    Humans? They couldn't tell right from wrong even if you labelled them.
    All they know is greed.
    {swap_char()}
    What do you mean?
    {swap_char()}
    Look at the wars they fight.
    Look how many of them are in poverty.
    And you mean to say that they know best?
    Don't make me laugh.
    {swap_char()}
    Who's to say that they don't? You?
    The last creature of a species long since extinct?
    Where are the plesiosaur cities? Where are the flounder-built factories?
    {swap_char()}
    ...
    {swap_char()}
    That's what I thought.
    {swap_char()}
    To be fair, I think I have an aunty in Scotland.
    {swap_char()}
    That proves my point even further, somehow.
* ["Says who?"]
    {swap_char()}
    Who are you to say that about the river?
    What about all the fish that didn't get a choice in what was best for the river before they died off?
    {swap_char()}
    Tessie, Tessie. Don't you know that I AM the river?
    Dirty Father Thames. As in the river Thames? I think I know what is best for myself.
    {swap_char()}
    Well, I guess you are qualified...
{force_char(NPC)} // No guarantee that the current character is the NPC after choice 1
- Who are you to even stop me? // Prompt 2
* ["Stop you?"]
    {swap_char()}
    Stop you? I'm trying to help you.
    You know this isn't right. You know that you aren't healthy.
    You can't go on like this.
    {swap_char()}
    I'm doing just fine as is!
    {swap_char()}
    You aren't. You can't even hide it anymore.
    I want to help you. I know you can get better.
    {swap_char()}
    ...
    I don't need your help!
    Just leave me alone...
    ~ choicespassed += 1
* ["An advocate."]
    {swap_char()}
    I'm a voice, here to tell you what is truly right.
    I'm an advocate for all of the fish that once lived in the river.
    {swap_char()}
    They're gone now. You're a voice for nothing that exists anymore.
    {swap_char()}
    But the lives in the river deserved to live - they deserved to be heard!
    {swap_char()}
    If they're not here now, I don't care.
* ["A warrior."]
    {swap_char()}
    I'm a warrior, here to defeat you, and return this river to what it once was.
    {swap_char()}
    Defeat me? You, a single fish, think you could defeat a whole river?
    Heh, seems pretty unlikely to me.
    {swap_char()}
    Don't underestimate me! I'm stronger than you think.
    {swap_char()}
    I doubt that, Tessie. You won't even be able to stop yourself being washed away.
{force_char(NPC)} // No guarantee that the current character is the NPC after choice 2
- This is your last chance to turn back, Tessie. // Prompt 3
* ["I'm ready to fight."]
    {swap_char()}
    I'm not backing down. I'm ready to fight you.
    I will save this river.
    {swap_char()}
    I doubt that. Say your last words.
* ["This is your last chance."]
    {swap_char()}
    No, this is YOUR last chance! 
    Go back to the way you once were, or I'll make you.
    {swap_char()}
    Ahahaha. 
    That's cute, Tessie. Am I supposed to be intimidated?
    You don't scare me at all.
* ["I won't give up."]
   {swap_char()}
   I won't give up on you.
   I know you need help, and you're isolating yourself because you're scared.
   It's okay to hurt. It's okay to be in pain.
   {swap_char()}
   I'm not-
   I'm not-
   {swap_char()}
   I'm here for you. 
   Even if it's one small thing I can do, that's so important.
   The journey of a thousand miles starts with a single step.
   {swap_char()}
   I-
   How dare you!
   I won't let you get away with trying to humiliate me! 
   ~choicespassed += 1
{force_char(NPC)} // The NPC will be having the final say
- /* Flirt decision here (the hyphen acts as a gather - please don't remove)
I'll assume that passing all three choices is an automatic success,
failing all three choices is an automatic failure,
and ending up in between will leave your chances of success to your charm stat.
*/
~ battlebonus += choicespassed
~ enable_charbox = false
{ 
- choicespassed == 3: // If you decide that some options are worth more than others
    {NPC}'s guard is down!
- choicespassed == 2:
    {NPC} is off balance!
- choicespassed == 1:
    {NPC} is looking distracted!
- else:
    {NPC} steels himself for battle!
}
-> END
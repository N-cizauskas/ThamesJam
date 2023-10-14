VAR battlebonus = 0 // This will track the bonus gained for the boss battle
CONST NPC = "The Politicians" // This is the character you are talking to.
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
// Individual Politicians' names
CONST BORIS = ""
CONST LIZ = ""
CONST RISHI = ""
CONST MAY = ""
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
Who are you?
{swap_char()}
We're politicians - we rule this country, and its rivers.
{force_char("Tessie")}
Why are you here?
{force_char(RISHI)}
Didn't you hear us? What happens to this river happens because what we say goes.
{force_char("Tessie")}
Don't fish run the river?
{force_char(BORIS)}
Hahaha!  The world relies on us.  Our decisions can destroy the world or save it.
{force_char("Tessie")}
So are you good or bad?
{force_char(LIZ)}
Well, of course we're good. 
{force_char(MAY)}
If we were bad then that would be wrong, and we could never be wrong.
{force_char("Tessie")}
And you want the river to stay healthy?
{swap_char()}
Of course.
{swap_char()}
Oh good.  Why are all the fish worried about things changing then?
{swap_char()}
It’s all spin they made up to try and make us look bad.
People will do anything to win an election these days.
{swap_char()}
They seemed genuinely worried about the river, though.
{force_char(NPC)}
We hear your concerns. // Prompt 1
* ["I have more."]
    {swap_char()}
    I have more concerns than that.
    {swap_char()}
    Go ahead.
    {swap_char()}
    The river's getting warmer.
    It's also getting more acidic.
    That means that the water feels uncomfortable to live in.
    For some fish, it's unbearable.
    For others, it might soon be fatal.
    The level of the river is rising, and soon it might break its banks, flooding London permanently.
    This could kill thousands of humans, and would permanently disrupt the life cycle of dozens of species.
    {swap_char()}
    ...
    {swap_char()}
    So? What are you gonna say about that?
    {swap_char()}
    Your concerns...
    They are heard.
    {swap_char()}
    Dear god.
* ["Is that all?"]
    {swap_char()}
    Is that all you do?
    Will you address the concerns? Will you change anything?
    {swap_char()}
    It'd be irresponsible to change things on a whim just because a few activists are raising their voices, don't you think?
    {swap_char()}
    Activists? I thought you were hearing our concerns? Or was that just another lie?
    {swap_char()}
    Now, now. Accusing us of lying is rather radical, don't you think? 
    We just want to keep things civil, that's all.
* ["Who can I trust?"]
    {swap_char()}
    You may hear our concerns, but who can I trust to hear them the most?
    {swap_char()}
    Trust the most?
    {force_char(BORIS)}
    Well, me, of course.
    {force_char(RISHI)}
    You? But I'm currently in office. Surely it must be me.
    {force_char(MAY)}
    But you're unproven! My tenure as leader was a great success.
    This country did great things - and I can do them again.
    {force_char(LIZ)}
    You may have been great, but I set records as Prime Minister.
    force_char(RISHI)
    I don't think "Shortest Tenure Ever" is a comforting record for voters.
    force_char(LIZ)
    But I made big changes! I could do so again!
    force_char(BORIS)
    God help this country if that ever happens. Vote for me, instead!
    {force_char(NPC)}
    No, me! Vote for me! Not them!
    {swap_char()}
    Hehehe...
    ~ choicespassed += 1
{force_char(NPC)} // No guarantee that the current character is the NPC after choice 1
- We have concerns that taking action would negatively affect the economy. // Prompt 2
* ["So what?"]
    
    
* ["It won't."]

* [""]
    
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
VAR battlebonus = 0 // This will track the bonus gained for the boss battle
CONST NPC = "The Politicians" // This is the character you are talking to.
VAR current_char = NPC // This variable tracks the currently talking character. It will be passed to the "current talker" box every time dialogue is continued
VAR choicespassed = 0 // Flags the number of times we make the correct choice
// VAR charmgain = 0 // Tracks the amount of charm gained in the flirt
// And this one tells us if the flirt has been passed
VAR flirtpassed = false
/* These variables likely do nothing here but they are here as a fail-safe to ensure that the code doesn't break upon loading this script */
VAR charm = 0
VAR threshold1 = 0
VAR threshold2 = 0
/* This variable determines whether the character box is displayed
Set it to false whenever you need the character box to be hidden.
e.g. for narrating a scene.
Set it to true whenever you need a character talking.
*/
VAR enable_charbox = true
// Individual Politicians' names
CONST BORIS = "Thoris"
CONST LIZ = "Thiz"
CONST RISHI = "Thishi"
CONST MAY = "Ththeresa"
CONST THATCHER = "Ththatcher"
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
    {force_char(RISHI)}
    I don't think "Shortest Tenure Ever" is a comforting record for voters.
    {force_char(LIZ)}
    But I made big changes! I could do so again!
    {force_char(BORIS)}
    God help this country if that ever happens. Vote for me, instead!
    {force_char(NPC)}
    No, me! Vote for me! Not them!
    {swap_char()}
    Hehehe...
    ~ choicespassed += 1
{force_char(NPC)} // No guarantee that the current character is the NPC after choice 1
- We have concerns that taking action would negatively affect the economy. // Prompt 2
* ["So what?"]
    So what if the economy is negatively affected?
    A healthy economy won't mean much if London is flooded.
    {swap_char()}
    How can you say that?
    The economy is our upmost priority as leaders of the country.
    To simply throw it away would mean losing the election!
    {swap_char()}
    What about people's lives? People could die. 
    Most of London could be uninhabitable for humans.
    Thousands of buildings unusable.
    How will that affect the economy?
    {swap_char()}
    We can't simply adopt long-term thinking at the cost of short-term gains!
    That would hurt shareholders, party donors, and business owners!
    {swap_char()}
    ...
    {swap_char()}
    But only large business owners.
    {swap_char()}
    This sucks.
* ["It won't."]
    {swap_char()}
    You say it'll hurt the economy, but that's because the economy is built to rely on carbon emissions.
    We can reduce our fossil fuel usage, and build a new green energy sector.
    {swap_char()}
    Go on?
    {swap_char()}
    This country could become a global leader of green and renewable energy manufacturing and design.
    Our place in the global economy is stabilised as other countries realise take the lead we set.
    Thousands and thousands of jobs in industrial manufacture and research stimulates the local economy.
    Plus, international trade becomes more important, and our trade relations improve after Thexit.
    {swap_char()}
    May I interject?
    {swap_char()}
    Go on...
    {swap_char()}
    Our analysts drew a graph of a prediction of the economy based on your plan.
    As you can see, the line goes down quite far.
    That's not good.
    {swap_char()}
    Argh! Why am I even trying?
* ["It can recover."]
    {swap_char()}
    It may hurt the economy, but it can recover.
    And one of you can lead the country in a period of healthy recover.
    {swap_char()}
    One of us?
    {swap_char()}
    Whichever of you is best suited to that once-in-a-lifetime situation.
    {force_char(BORIS)}
    Well, that would be me, of course.
    I had to deal with two once-in-a-lifetime situations while I was PM.
    {force_char(MAY)}
    Just don't ask a member of public how well you handled them...
    {force_char(LIZ)}
    I could-
    {force_char(RISHI)}
    No.
    {force_char(BORIS)}
    No.
    {force_char(MAY)}
    No.
    {force_char(RISHI)}
    I imagine that the job would fall to me, as I'm the current leader.
    {force_char(NPC)}
    Not you! You couldn't do it! I'd be much better.
    {swap_char()}
    They really can't help it, can they?
    ~ choicespassed += 1
{force_char(NPC)} // No guarantee that the current character is the NPC after choice 2
- But what about our legacies as great Prime Ministers?! // Prompt 3
* ["Look at yourselves."]
    Look at yourselves.
    Three of the four of you have left office already.
    Your time to make a legacy has already gone.
    On top of that, your tenures were filled with failure and scandal as is.
    {swap_char()}
    We still have time to fix that, though!
    {swap_char()}
    Fix it? I doubt it.
    None of you could be a Thurchill or a Ththatcher.
    No matter how hard you tried.
    {force_char(RISHI)}
    I'm still in power, though! I can make my mark!
    {force_char(MAY)}
    If you can survive the election, that is.
    {force_char(BORIS)}
    The people still love me! You should've seen what they said about me!
    {force_char(LIZ)}
    I set records, you know! I made a monumental impact!
    {force_char(MAY)}
    It's not exactly a record to be proud of...
    {force_char(LIZ)}
    But my name! It'll be in history books.
    {force_char(NPC)}
    No! Mine will! I'll be remembered forever.
    {swap_char()}
    How can they be so selfish?
    It's time to end this.
    ~ choicespassed += 1
* ["This will be it."]
   {swap_char()}
   You can make saving the climate your legacy.
   At the last moment, from the jaws of extinction, humanity's survival ensured!
   Marine life in the Thames spared from being wiped out by pollution.
   Again.
   {swap_char()}
   We're not so sure...
   {swap_char()}
   What do you mean?
   {swap_char()}
   Well, the people we're trying to please...
   The people who would enshrine our monumental legacies among those of the greats...
   They wouldn't like it!
   {swap_char()}
   Oh for goodness' sake.
* ["Not worth it."]
    {swap_char()}
    But what is the point of having a legacy when there will be no-one around to observe it?
    It's not worth it to worry about how you will be remembered.
    When the climate changes drastically, it could be that all of this, and all of you, are forgotten.
    Because humanity is driven to the brink of collapse.
    And because remembering you is the least of people's worries.
    {swap_char()}
    What is there worth governing for if our names won't be in the history books?
    {swap_char()}
    Is that all you care about? 
    Your own self-image, and a selfish desire for something that you will never get to see?
    {swap_char()}
    It's not all we care about!
    But it's a big part of it.
    {swap_char()}
    You're all pathetic.
    And evil.
    {swap_char()}
    How could you put our dreams down like that?!
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
    {NPC}'s guards are down!
- choicespassed == 2:
    {NPC} are off balance!
- choicespassed == 1:
    {NPC} are looking distracted!
- else:
    {NPC} steel themselves for battle!
}
-> END
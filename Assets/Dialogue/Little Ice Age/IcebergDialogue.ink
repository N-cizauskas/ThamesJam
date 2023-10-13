// Define some variables we will be using
VAR battlebonus = 0 // This will track the bonus gained for the boss battle
CONST NPC = "Iceberg" // This is the character you are talking to.
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
Why are you doing this to the Thames? Can't you see the life inside the river is suffering from this drastic change?
{swap_char()}
So what? We all suffer. I used to be a glacier a long time ago.  
But orbital changes, volcanic activity, ocean currents... all these things made me this way. 
Humans build bridges, preventing my travel to the ocean. 
Why should I care about others after nobody has ever cared about me?
{swap_char()}
Just because you are suffering doesn't mean you should make others suffer, too.
{swap_char()}
You and I are alike. We both don't belong here.  
Your species should be long extinct, and I should be drifting in the northernmost ocean.  
You can't tell me to leave without exulting yourself, too.
{swap_char()}
I may not belong here, but I respect the Thames and everyone living inside of it.






{force_char(NPC)}
- Why should I care about others when nobody has ever cared about me? // Prompt 1
* ["They deserve to be happy!"]
    {swap_char()}
    Because the life in the Thames deserve better than this.
    They deserve to be happy!
    {swap_char()}
    Happiness is a luxury.
    {swap_char()}
    It's easily attainable in your absense, though.
    {swap_char()}
    So I should die to make others happier?
    {swap_char()}
    The needs of the many outweight that of the few.
    {swap_char()}
    Anyone else would do the same in my circumstances.
* ["It's easy to be cruel"]
    {swap_char()}
    Because sometimes we need to show others kindness even though we haven't been shown it ourselves.
    {swap_char()}
    It's not fair. Why do I need to be the one to leave every time?
    I know that it's not fair. You don't deserve to be kicked out of your home in the North.
    But the life in the Thames is at your mercy. 
    {swap_char()}
    I'm at the mercy of my circumstances, too...
    {swap_char()}
    It's easy to be cruel when that's all you know. It's harder to show compassion when you've never experienced it.
    Come on, let's end this cycle of cruelty.
    {swap_char()}
    I don't know... I don't want to be cruel.
    Obviously, nobody wants to be heartless.  Some people just end up this way.
    If I show kindness to the Thames by leaving, I will melt away in the heat of the ocean.
    I am selfish. I'm scared to die. Can you blame me?
    This is the best I can do.
    {swap_char()}
    You can do better, I know you can. You can be kind.
    {swap_char()}
    I don't know...
     ~ choicespassed += 1 
* ["Stop being so emo"]
    {swap_char()}
    You're hurting people! Stop being so emo and realise it!
    {swap_char()}
    I know I'm hurting people!
    {swap_char()}
    Then why are you doing it?
    {swap_char()}
    Because I have no choice! My being here makes the river freeze over.
    If I leave, I will die. I'll melt in the ocean.
    {swap_char()}
    Then die.
    {swap_char()}
    I don't want to die!
    {swap_char()}
    Why can't you be more emo when it's suitable for the plot?
    {swap_char()}
    You're terrible!

    







{force_char(NPC)} // No guarantee that the current character is the NPC after choice 1
- I don't want to die. Is that so hard to understand? // Prompt 2
* ["Nobody wants to die!"]
    {swap_char()}
    Well you shouldn't have wrecked havoc across the river then!
    {swap_char()}
    I told you, I had no choice! I'll die in the ocean!
    {swap_char()}
    Yeah, so? That is what you're meant to do.
    {swap_char()}
    Cruel! I don't want to die!
    {swap_char()}
    Nobody wants to die!
    {swap_char()}
    So why me?!
    {swap_char()}
    Because you're an evil boss! That's what's supposed to happen! It is in the script!
    {swap_char()}
    Boss? Script? What are you on about?
* ["We all die"]
    {swap_char()}
    We all die eventually. It's a normal thing to do.
    Nothing to be scared of.
    {swap_char()}
    Even if you say that, it's terrifying to enter a state you can't imagine beforehand.
    {swap_char()}
    It will happen even if you're scared of it.
    {swap_char()}
    But will it be painful? Will I be at peace?
    Will I have moments of panic as I melt away into nothing, where I want to go back, but it's too late?
    {swap_char()}
    Dying is always like that. You don't get special rights to abuse others because you're facing the same suffering we all eventually do.
    {swap_char()}
    Even so! I don't want to!
* ["The unknown is scary."]
    {swap_char()}
    I do understand. The unknown is scary.
    {swap_char()}
    And you still ask it of me?
    {swap_char()}
    You can't keep living like this. Eventually, it will warm up and you will melt anyway.
    {swap_char()}
    Then let me struggle on like this.
    {swap_char()}
    How much damage will you do until then, though? Is it worth it?
    {swap_char()}
    ...
    {swap_char()}
    Is it worth clinging on like this, when all you're doing is hurting the others around you?
    {swap_char()}
    No...
    {swap_char()}
    It's okay to be scared, but prolonging the inevitable will hurt you more as well.
    {swap_char()}
    I know...
    ~ choicespassed += 1









{force_char(NPC)} // No guarantee that the current character is the NPC after choice 2
- Prove to me that you, like a god, can determine who lives and who dies. // Prompt 3
* ["Let's find out."]
    {swap_char()}
    This isn't a role I imagined myself in, but I will happily become a god to save the Thames.
    {swap_char()}
    Do you have what it takes?
    Can you handle the weight of your decisions?
    {swap_char()}
    Let's find out.
    ~ choicespassed += 1
* ["Don't shoot the messenger."]
    {swap_char()}
    These decisions were always predetermined. Don't shoot the messenger.
    {swap_char()}
    You are more than a messenger. You're my antagonist!
    {swap_char()}
    If not for me, someone else would confront you.
    And even if that didn't happen, you'd still die eventually.
    {swap_char()}
    Everyone dies eventually! what kind of logic is that supposed to be? 
* ["Ok, I will."]
   {swap_char()}
   Ok, I will.
   {swap_char()}
   What is wrong with you?!
   Have you no shame?
   {swap_char()}
   No, I'm always right.








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
    {NPC} steels itself for battle!
}
-> END
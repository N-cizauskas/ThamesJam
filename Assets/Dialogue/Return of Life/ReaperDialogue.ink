// Define some variables we will be using
VAR battlebonus = 0 // Tracks the bonus gained for the following battle
VAR charm = 0 // The idea is to get the charm from the game stat (somehow)
VAR threshold1 = 0 // Threshold charm for passing if you passed only one choice
VAR threshold2 = 0 // The same, but for passing two choices
CONST NPC = "Death" // This is the character you are talking to.
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
No wonder everyone's been on edge around here...
Long time no see, Death.
{swap_char()}
GREETINGS, TESSIE
{swap_char()}
What are you doing here? 
{swap_char()}
I AM A PART OF THE NATURAL LIFE CYCLE.
WITH NEW LIFE COMES NEW DEATH.
I AM HERE TO TAKE WHAT IS MINE. // Prompt 1
* ["Too Soon"]
    {swap_char()}
    But life has only just returned to the Thames!
    Isn't it too soon to take it away?
    {swap_char()}
    NO TIME IS TOO SOON OR TOO LATE.
    DEATH ARRIVES WHEN IT MUST.
    {swap_char()}
    I don't believe that.
    {swap_char()}
    I AM NOT BELIEFS. I AM NOT WANTS OR WISHES.
    I AM THE TRUTH AT THE END OF IT ALL.
* ["It's cruel"]
    {swap_char()}
    But look at all the life in the river! It's cruel to take it all away!
    {swap_char()}
    NOT ALL, TESSIE.
    JUST THAT WHICH IS TO BE TAKEN.
    I KNOW YOU UNDERSTAND.
    {swap_char()}
    You know what I mean.
    Look at all the happiness here.
    You'd take that away after so long without anything?
    {swap_char()}
    ...
    ...
    I HAVE A DUTY TO FULFILL.
    ~ choicespassed += 1
* ["Go elsewhere"]
    {swap_char()}
    But can't you go elsewhere?
    Surely there are places where you can reap more death than here?
    {swap_char()}
    WHERE THERE IS LIFE, THERE IS DEATH.
    I AM THERE AND I AM ALSO HERE.
    {swap_char()}
    Well that's confusing...
{force_char(NPC)} // No guarantee that the current character is the NPC after choice 1
- MY PRESENCE IS INEVITABLE. // Prompt 2
* ["Not required."]
    {swap_char()}
    It may be inevitable, but that doesn't mean you have to be here right now.
    You could come back, slowly, over time, and take what is yours in due course.
    {swap_char()}
    THAT CHANGES NOTHING.
    DO YOU NOT SEE THAT, TESSIE.
    {swap_char()}
    Maybe not for you, but for this river, it means that life thrives and the river glows with life.
    This river has been lonely for too long.
    You wouldn't take away all that happiness prematurely, would you?
    {swap_char()}
    ...
    I WILL NOT ABANDON MY PURPOSE FOR MORTAL EMOTION.
    I WILL NOT FEEL.
    ~ choicespassed += 1
* ["I disagree."]
    {swap_char()}
    I disagree. Nothing is inevitable.
    I don't believe in fate, and I sure won't let fate walk right past me when it threatens to hurt my friends.
    {swap_char()}
    FATE DOES NOT WALK BY.
    IT APPEARS BEHIND YOU WHEN YOU AREN'T LOOKING.
    IT STRIKES IN THE NIGHT, WHEN YOUR GUARD IS DOWN.
    YOU THINK YOU CAN DEFEND THIS RIVER, FOREVER?
    {swap_char()}
    Of course I can!
    {swap_char()}
    DO NOT BE FOOLISH.
    ONE DAY YOU WILL CLOSE YOUR EYES AND THE LAST OF YOUR FRIENDS WILL BE GONE.
    AND YOU WILL REGRET SPENDING SO MUCH TIME FIGHTING AND SO LITTLE LIVING.
    AND THEN YOU WILL SUBMIT TO ME, TOO.
    NO ONE CAN BEAT DEATH.
* ["Nice act."]
    This is a nice act you've got going, but you aren't going to intimidate me.
    I am hardier than you think.
    {swap_char()}
    YOU LIE, TESSIE. I AM NO STRANGER TO LIES.
    I CAN FEEL YOUR FEAR. IT PERMEATES YOUR BEING.
    YOU ARE NO LESS IMMUNE TO IT THAN EVERY OTHER FISH IN THIS RIVER.
    {swap_char()}
    I...
    {swap_char()}
    THE FACE, ONCE BRAVE, NOW REVEALS THE FEAR HIDDEN INSIDE.
    I CAN TAKE AWAY THAT FEAR THAT FOLLOWS YOU EVERYWHERE YOU GO.
{force_char(NPC)} // No guarantee that the current character is the NPC after choice 2
- NOTHING CAN ESCAPE DEATH, TESSIE. YOU CANNOT STOP ME FOREVER. // Prompt 3
* ["More time"]
    {swap_char()}
    All I'm asking for is more time.
    Just to enjoy the feeling of community for the first time in a hundred years.
    {swap_char()}
    YOUR COMMUNITY WILL NOT SURVIVE WITHOUT DEATH.
    HOW WILL THE PREDATORS LIVE WITHOUT KILLING THEIR PREY.
    YOUR WISHES ARE FOLLY.
    {swap_char()}
    I'm not asking you to completely end death in the river.
    But if you're manifested here, that must mean that a lot of death will happen soon.
    And that means that I can ask you to stop what you're doing and let life take its natural course.
    {swap_char()}
    ...
    I SUPPOSE THAT MAY BE TRUE.
    AN EXCEPTION COULD BE MADE.
    {swap_char()}
    Then do that for me? 
    It's been so long since I have seen the river like this.
    This river deserves more time.
    Please.
    {swap_char()}
    ...
    NO!
    YOU CANNOT MAKE ME FEEL THESE MORTAL EMOTIONS!
    I WILL END YOU NOW IF I MUST!
    ~ choicespassed += 1
* ["I can try"]
    {swap_char()}
    I've done a pretty good escaping you so far.
    If I can do so myself, who's to say I can't do so for the river?
    {swap_char()}
    YOU MAY HAVE EVADED DEATH AND EXTINCTION, BUT YOU ARE AN ODDITY.
    EVEN THEN, YOU WILL STOP RUNNING BEFORE I DO.
    {swap_char()}
    ...
    {swap_char()}
    TELL ME TESSIE.
    WILL YOU SAVE EVERYONE IN THIS RIVER, FOREVER?
    WHAT ABOUT ALL THE RIVERS.
    WHAT ABOUT ALL THE OCEANS.
    {swap_char()}
    ...
    {swap_char()}
    THERE IS TOO MUCH LIFE.
    I AM INESCAPABLE.
* ["I will win."]
   I'm stronger than you. I will win.
   {swap_char()}
   SUCH ARROGANCE. HOW COULD A MORTAL BEAT DEATH.
   ALL YOU CAN DO IS DELAY FATE.
   {swap_char()}
   So you're saying I could win in a fight against you?
   {swap_char()}
   I WILL HOLD BACK, AS IT IS NOT YOUR TIME.
   BUT NO.
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
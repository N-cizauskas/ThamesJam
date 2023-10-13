// Define some variables we will be using
VAR battlebonus = 0 // This will track the bonus gained for the boss battle
CONST NPC = "The Storm" // This is the character you are talking to.
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
What are you doing?!
{swap_char()}
I'm being myself.
{swap_char()}
But this flood... it's destroyed so many homes and animals
{swap_char()}
Nobody understands me. Everyone I meet wants to change me. 
Why can't anyone just accept me for who I am?  
I bet you want to change me too.
{swap_char()}
Is this really who you are?
{swap_char()}
If you don't like me at my worst, you don't deserve me at my best.
{force_char(NPC)}
- So what if I caused a flood! I was having a bad day, okay? // Prompt 1
* ["Spill the tea!"]
    {swap_char()}
    That is not an appropriate reaction to having a bad day!
    {swap_char()}
    Ugh, if you saw the day I had... believe me, you would understand.
    {swap_char()}
    Spill the tea!
    {swap_char()}
    So there's this other cloud... a total nimbostratus! And I was all, like...
    {swap_char()}
    Go on!
    {swap_char()}
    Wait, why am I telling you this? Get lost!
* ["We all have bad days"]
    {swap_char()}
    Was it really that bad of a day?
    {swap_char()}
    Yes! The worst ever!
    {swap_char()}
    We all have bad days sometimes.  You can't just cause a flood because you're upset.
    {swap_char()}
    I can't help it! I just get so angry and frustrated... and then BOOM! Water everywhere!
    {swap_char()}
    Can you really not control it?
    {swap_char()}
    Well... well... there are ways! But it's hard when everything is going wrong at once!
    {swap_char()}
    What ways?
    {swap_char()}
    It's too hard!
    ~ choicespassed += 1 
* ["You're crazy!"]
    {swap_char()}
    You're crazy! This is insane!
    {swap_char()}
    Um, okay? All the hottest clouds are a little crazy!
    {swap_char()}
    No, this is unhinged. You need help.
    {swap_char()}
    Isn't that what you're here to do?
    {swap_char()}
    Oh, yeah. I guess.
    {swap_char()}
    Lol.
{force_char(NPC)} // No guarantee that the current character is the NPC after choice 1
- Haven't you ever gotten so frustrated you hurt someone? // Prompt 2
* ["No, I would never do that."]
    {swap_char()}
    No, I would never do that.
    Unlike you, I can control my emotions.
    {swap_char()}
    Well, woo-hoo for you. Must be nice being perfect.
    {swap_char()}
    It's not even hard...
    {swap_char()}
    Maybe my life is more stressful than yours. How would you know?
    {swap_char()}
    How stressful could being a cloud be? You just float around.
    {swap_char()}
    No! We have to take up all the gunky water and release it periodically! It's hard!
    {swap_char()}
    Uh-huh...
* ["Yes, I have."]
    {swap_char()}
    Yes, I have. It's hard to calm down when you're so agitated.
    {swap_char()}
    So you get it, then.
    {swap_char()}
    Well, I understand where you're coming from.
    But since I've hurt someone before, I know I need to control my anger.
    I don't want to hurt anyone like that again, so I manage my emotions.
    {swap_char()}
    Manage them? How? It's not that easy.
    I wouldn't be like this if I could choose not to.
    {swap_char()}
    Well, I walk away from the situation first. Let out steam alone, where I can come to terms with how I'm feeling.
    Then I reach out to others for help when I know I'll be more receptive.
    {swap_char()}
    You make it sound easy....
    ~ choicespassed += 1
* ["But not like this!"]
    {swap_char()}
    Probably. But not like this!
    {swap_char()}
    What do you mean?
    {swap_char()}
    You caused a devastating flood! You displaced so many people and animals!
    {swap_char()}
    Ok... I was mad, though.
    {swap_char()}
    You directly caused people's deaths!
    {swap_char()}
    They could have prepared better. It's not my fault they handled it so badly.
    {swap_char()}
    You're so toxic!
{force_char(NPC)} // No guarantee that the current character is the NPC after choice 2
- Ugh, I'm geting angry again...! // Prompt 3
* ["Just calm down!"]
    {swap_char()}
    Just calm down!
    {swap_char()}
    Don't tell me to calm down!
* ["Take a deep breath."]
    {swap_char()}
    Take a deep breath.
    Let's take it slowly, okay?
    {swap_char()}
    I'm... trying... but I can't help it...
    The rage is building...
    ...
    ~ choicespassed += 1
* ["Why?"]
   {swap_char()}
   Why? What is there for you to be angry about right now?
   {swap_char()}
   You! You're making me angry!
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
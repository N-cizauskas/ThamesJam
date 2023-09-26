// Define some variables we will be using
VAR charm = 0 // The idea is to get the charm from the game stat (somehow)
VAR threshold = 5 // This variable is generally fixed but could be modified depending on the circumstances
// These two variables flag whether we have made the correct choice at each step
VAR choice1passed = false
VAR choice2passed = false
// And this one tells us if the flirt has been passed
VAR flirtpassed = false

-> main
== function mod_stats(ref stat,val) ==
// Helper to change the stat by a certain defined amount
// Given how simply it is used, there's actually no need for this.
    ~ stat += val
== main ==
// Introductory dialogue
Testing dialogue 1. Current charm is {charm}.
Testing dialogue 2! Make a choice.
    /* For the choices, enclosing the choice text in square dialogues
        will prevent the choice name from appearing in subsequent dialogue
        (The names in round brackets are optional, and are for ink script navigation.
        Such navigation is not employed here)
    */
    + (choice1) [Choice 1]
        // Dialogue after picking choice 1
        // (The dialogue is an ink tutorial!)
        You picked the first option.
        We can arbitrarily mark this option as correct,
        by setting the variable in inky like so:
        ~ choice1passed = true
        \(Please read the code, it makes more sense there)
        Anyway, here are two more choices:
        ** [Choice 1a]
            // Dialogue after picking choice 1a
            This is branch 1a, which is incorrect.
        ** [Choice 1b]
            // Dialogue after picking choice 1b
            This is branch 1b, which is correct.
            ~ choice2passed = true
        -- Additional dialogue after this choice
    + (choice2) [Choice 2]
        // Dialogue after picking choice 2
        You picked the second option.
        This option is arbitrarily marked as incorrect.
        But you can still redeem yourself!
        ** [Choice 2a]
            // Dialogue after picking choice 2a
            Branch 2a is incorrect.
        ** [Choice 2b]
            // Dialogue after picking choice 2b
            Branch 2b is correct.
            ~ choice2passed = true
        -- Additional dialogue after choice 2
// Dialogue that occurs after both choices have been made
- Now we merge back after the sub-branches.
We will now decide whether or not we passed the flirt.
{ /* This works as a series of if/else statements
    Depending on whether the choice1passed and/or choice2passed booleans have been marked true,
    we branch into different outcomes
*/
- choice1passed && choice2passed: // If both have been set to true
    By getting both answers correct you automatically pass the flirt.
    ~ flirtpassed = true
- not (choice1passed || choice2passed): // If both are false
    By getting both answers wrong you automatically fail the flirt.
- else:
    If only one of the answers are correct, we determine based on the charm to see if the flirt succeeds;
    { // Like with other coding languages you can nest your if/else statements!
    - charm >= threshold: // Check if charm stat is at least equal to the threshold
        The flirt succeeds if you make the charm threshold.
        ~ flirtpassed = true
    - else:
     The flirt fails if you fail to make the charm threshold.
    }
}
{
// If we have succeeded in our flirt, reward the player with charm stats (or other bonuses!)
- flirtpassed: If our flirt has succeeded, we also set the modification of charm, depending on the answers that were correct.
    {
    - choice1passed && choice2passed:
        Getting both right might add 3 charm, for example
        {mod_stats(charm,3)}
        Your charm increased by 3! Your charm is now at {charm}!
    - choice1passed && not choice2passed:
        If you get the second one wrong, you would get less charm
        {mod_stats(charm,2)}
        Your charm increased by 2! Your charm is now at {charm}!
    - choice2passed && not choice1passed:
        If you get the first one wrong, you would get less charm
        {mod_stats(charm,1)}
        Your charm increased by 1! Your charm is now at {charm}!
    }
}
-> END
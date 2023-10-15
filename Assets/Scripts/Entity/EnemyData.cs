using System;
using UnityEngine;

[CreateAssetMenu]
public class EnemyData : ScriptableObject
{
    // JY: Setting this as a property (with getter/setter) rather than a field, so that it isn't serialized
    //     (making it appear in the editor would only be confusing as it's set by the Enemy script)
    public Vector3 OverworldPosition {get; set;}

    public Vector2 EncounterSpritePosition;
    public String Name;
    public String Subtext;
    public Sprite Sprite;
    public TextAsset FlirtDialogue;
    public int Speed;  // used in BattleManager. How much the enemy's tug value increases each second. 100 means a tug is performed every second.
    public int Strength;  // used in BattleManager. How much the enemy's tugs decrease leverage by. battle leverage is between 0 and 100.
    public int CharmThreshold1; // used in DialogueManager. How much charm is needed to pass if only one correct option has been given
    public int CharmThreshold2; // used in DialogueManager. How much charm is needed to pass if only two correct options have been given
    public bool IsBoss; // Determines if enemy is a boss and if anything special should happen
    public int BossCheck; //From Joe, Boss only so that Ending battles work.       Non Boss = 0

    public TextAsset PostBossDialogue;
}

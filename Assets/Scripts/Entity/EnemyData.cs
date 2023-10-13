using System;
using UnityEngine;

[CreateAssetMenu]
public class EnemyData : ScriptableObject
{
    // JY: Setting this as a property (with getter/setter) rather than a field, so that it isn't serialized
    //     (making it appear in the editor would only be confusing as it's set by the Enemy script)
    public Vector3 OverworldPosition {get; set;}
    public String Name;
    public String Subtext;
    public Sprite Sprite;
    // to add: dialogue?
    public int Strength;
    public int Dexterity;
    public int Finesse;
}

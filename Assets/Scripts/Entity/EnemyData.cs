using System;
using UnityEngine;

[CreateAssetMenu]
public class EnemyData : ScriptableObject
{
    public String Name;
    public String Subtext;
    public Sprite Sprite;
    // to add: dialogue?
    public int Strength;
    public int Dexterity;
    public int Finesse;
}

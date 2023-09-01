using System;
using System.Linq;
using UnityEngine;
using Random = UnityEngine.Random;

// Extension method for Enums to get a random value from them. 
public static class EnumExtensions
{
    public static Enum GetRandomEnumValue(this Type t)
    {
        return GetRandomEnumValue(t, Enumerable.Repeat(1, Enum.GetValues(t).Length).ToArray());
    }

    /* Selects from a set of options based on integer weights; the greater the weight, the higher the probability of being selected
     * e.g. For 3 items with weight array [1, 3, 6], there's a 10%, 30% and 60% chance of selecting the three items respectively.
    */
    public static Enum GetRandomEnumValue(this Type t, int[] weights)
    {
        if (!t.IsEnum) {
            throw new ArgumentException("GetRandomEnumValue must be on an enumerated type");
        }

        if (weights.Length != Enum.GetValues(t).Length) {
            throw new ArgumentException("length of weight array and enum values are mismatched");
        }

        int randomValue = Random.Range(1, weights.Sum() + 1);
        int threshold = 0;
        for (int i = 0; i < weights.Length; i++) {
            threshold += weights[i];
            if (randomValue <= threshold) {
                return (Enum) Enum.GetValues(t).GetValue(i);
            }
        }
        
        // should not reach this point
        Debug.LogWarning("random enum from weights did not work; returning null");
        return null;
    }
}

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

// Extension methods for picking random values from arrays and lists.
// Adapted from http://csharphelper.com/blog/2018/04/make-extension-methods-that-pick-random-items-from-arrays-or-lists-in-c/
public static class ArrayExtensions
{
    public static T GetRandomElement<T>(this T[] items, bool withReplacement=true)
    {
        return items[Random.Range(0, items.Length)];
    }

    // Picking a random value from a list; withReplacement allows the object to be removed if required
    public static T GetRandomElement<T>(this List<T> items, bool withReplacement=true)
    {
        T item = items[Random.Range(0, items.Count)];
        if (!withReplacement) {
            items.Remove(item);
        }
        return item;
    }

    // Shuffles a list in-place using the Fisher-Yates shuffle
    public static void Shuffle<T>(this List<T> items) {
        for (int i = items.Count - 1; i >= 1; i--) {
            // pick a value k from 1 to i, and swap elements k and i
            int swap = Random.Range(1, i+1);

            T tmp = items[swap];
            items[swap] = items[i];
            items[i] = tmp;
        }
    }

}

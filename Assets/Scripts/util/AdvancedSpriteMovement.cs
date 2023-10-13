/**
 * A component to more conveniently handle complex-ish movement over time for sprites.
**/

using System.Collections;
using System.Collections.Generic;
using Unity.Mathematics;
using UnityEngine;

public class AdvancedSpriteMovement : MonoBehaviour
{
    private SpriteRenderer sr;

    void Awake()
    {
        sr = GetComponent<SpriteRenderer>();
        sr.color = new Color(1, 1, 1, 0);   // white but transparent
    }

    // high level 'pop' function that just makes it bounce
    // TODO: to make this more fancy, maybe deal with rotation (eulerangles) x and y to give it the paper mario spinny effect
    public void Pop(Vector2 location, float popDuration, float fadeDuration)
    {
        transform.position = location;
        StartCoroutine(PopSequence(popDuration, fadeDuration));
    }

    private IEnumerator PopSequence(float popDuration, float fadeDuration)
    {
        sr.color = Color.white;
        // let's just make it scale from 0 to 1.5 to 1, and then afterwards alpha linearly to 0
        float elaspedTime = 0;
        while (elaspedTime < popDuration)
        {
            // map progress from 0 to 1; set scale to some quadratic function
            float progress = math.remap(0, popDuration, 0, 1, elaspedTime);
            float scale = -3 * math.pow(progress, 2) + 4 * progress;    // -3x^2 + 4x
            transform.localScale = new Vector3(scale, scale, 1);
            elaspedTime += Time.deltaTime;
            yield return null;
        }

        elaspedTime = 0;
        while (elaspedTime < fadeDuration)
        {
            float progress = math.remap(0, fadeDuration, 0, 1, elaspedTime);
            float alpha = 1 - progress;
            sr.color = new Color(1, 1, 1, alpha);
            elaspedTime += Time.deltaTime;
            yield return null;
        }
    }

}

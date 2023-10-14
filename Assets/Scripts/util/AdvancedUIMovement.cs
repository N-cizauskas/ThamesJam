/**
 * A component to more conveniently handle complex-ish movement over time for UI elements.
**/

using System.Collections;
using System.Collections.Generic;
using Unity.Collections;
using Unity.Mathematics;
using UnityEngine;

public class AdvancedUIMovement : MonoBehaviour
{
    public enum MoveType {
        LINEAR,
        EASE_OUT
    }

    public Vector2 AnchoredPosition {
        get {
            return rt.anchoredPosition;
        }
    }

    private RectTransform rt;

    void Awake()
    {
        rt = GetComponent<RectTransform>();
    }

    public void MoveTo(Vector2 targetLocation)
    {
        rt.anchoredPosition = targetLocation;
    }

    public void MoveTo(Vector2 targetLocation, float durationInSeconds, MoveType moveType)
    {
        StopAllCoroutines();
        switch (moveType)
        {
            case MoveType.LINEAR:
            {
                StartCoroutine(LinearMove(rt.anchoredPosition, targetLocation, durationInSeconds));
                break;
            }
            case MoveType.EASE_OUT: 
            {
                StartCoroutine(EaseOutMove(rt.anchoredPosition, targetLocation, durationInSeconds));
                break;
            }
            default:
            {
                Debug.LogWarning("unknown movement type requested");
                break;
            }
        }

    }

    private IEnumerator LinearMove(Vector2 currentLocation, Vector2 targetLocation, float durationInSeconds)
    {
        float elaspedTime = 0;
        Vector2 difference = targetLocation - currentLocation;

        while (elaspedTime < durationInSeconds)
        {
            elaspedTime += Time.deltaTime;
            rt.anchoredPosition += (Time.deltaTime / durationInSeconds) * difference;
            yield return null;
        }
        rt.anchoredPosition = targetLocation;
    }

    private IEnumerator EaseOutMove(Vector2 currentLocation, Vector2 targetLocation, float durationInSeconds)
    {
        float elaspedTime = 0;
        Vector2 difference = targetLocation - currentLocation;

        while (elaspedTime < durationInSeconds)
        {
            elaspedTime += Time.deltaTime;
            // the earlier the elasped time, the greater the speed - vary it from 2x to 0x across the period
            float multiplier = math.remap(0f, durationInSeconds, 2f, 0f, elaspedTime);

            rt.anchoredPosition += (Time.deltaTime * multiplier / durationInSeconds) * difference;
            yield return null;
        }
        rt.anchoredPosition = targetLocation;
    }
}

using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Image = UnityEngine.UI.Image;

public class OverlayFlash : MonoBehaviour
{
    [Header("Flash data (only for debugging!)")]
    [SerializeField]
    private Color flashColor;
    [SerializeField]
    private float flashAlpha;

    private Image image;

    // Start is called before the first frame update
    void Start()
    {
        image = GetComponent<Image>();
    }

    void Update()
    {
        image.color = new Color(flashColor.r, flashColor.g, flashColor.b, Mathf.Clamp(flashAlpha, 0, 1));
    }

    // fades in and out; fadeDuration -> holdDuration -> fadeDuration
    public void FadeInOut(Color color, float fadeDurationInSeconds, float holdDurationInSeconds)
    {
        StopAllCoroutines();
        this.flashColor = color;
        this.flashAlpha = 0;
        StartCoroutine(FadeInOut(fadeDurationInSeconds, holdDurationInSeconds));
    }

    public void Flash(Color color, float durationInSeconds)
    {
        StopAllCoroutines();
        this.flashColor = color;
        this.flashAlpha = 1;
        StartCoroutine(FlashSequence(durationInSeconds));
    }

    private IEnumerator FadeInOut(float fadeDurationInSeconds, float holdDurationInSeconds)
    {
        // fade in
        while (this.flashAlpha <= 1)
        {
            this.flashAlpha += Time.deltaTime / fadeDurationInSeconds;
            yield return null;
        }
        this.flashAlpha = 1;
        // hold
        yield return new WaitForSeconds(holdDurationInSeconds);
        // fade out
        while (this.flashAlpha >= 0)
        {
            this.flashAlpha -= Time.deltaTime / fadeDurationInSeconds;
            yield return null;
        }
        this.flashAlpha = 0;
    }
    
    private IEnumerator FlashSequence(float durationInSeconds)
    {
        while (this.flashAlpha >= 0)
        {
            this.flashAlpha -= Time.deltaTime / durationInSeconds;
            yield return null;
        }
        this.flashAlpha = 0;
    }
}

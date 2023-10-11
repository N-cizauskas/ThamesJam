using System.Collections;
using System.Collections.Generic;
using Microsoft.Unity.VisualStudio.Editor;
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

    public void Flash(Color color, float durationInSeconds)
    {
        this.flashColor = color;
        this.flashAlpha = 1;
        StartCoroutine(FlashSequence(durationInSeconds));
        Debug.Log("flash");
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

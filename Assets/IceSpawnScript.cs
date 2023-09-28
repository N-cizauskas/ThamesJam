using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class IceSpawnScript : MonoBehaviour
{
    
    public GameObject Icicle;
    public float spawnRate = 2;
    private float timer = 0;
    

    // Start is called before the first frame update
    void Start()
    {
        spawnIce();
    }

    // Update is called once per frame
    void Update()
    {
        if (timer < spawnRate)
        {
            timer = timer + Time.deltaTime;
        }
        else
        {
            spawnIce();
            timer = 0;
        }

    }

    void spawnIce()
    {
        
        Instantiate(Icicle, new Vector3(transform.position.x, transform.position.y, 0), transform.rotation);
    }
}
 


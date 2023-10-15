using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/**
 * Stores any important enemy behaviour and data
**/
public class Enemy : MonoBehaviour
{
    void Start()
    {
        EnemyData.OverworldPosition = transform.position;   // TODO: If we expect enemies to move, this should be in Update() instead
    }

    [field: SerializeField]
    public EnemyData EnemyData {get; private set;}

    
        private void OnTriggerEnter2D(Collider2D collision)

    {
        Destroy(gameObject);

    }
    
}

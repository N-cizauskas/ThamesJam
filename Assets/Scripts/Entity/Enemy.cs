using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/**
 * Stores any important enemy behaviour and data
**/
public class Enemy : MonoBehaviour
{
    [field: SerializeField]
    public EnemyData EnemyData {get; private set;}
}

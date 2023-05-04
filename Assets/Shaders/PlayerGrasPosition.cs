using System.Collections;
using System.Collections.Generic;
using UnityEngine;


[ExecuteInEditMode]
public class PlayerGrasPosition : MonoBehaviour
{
    [SerializeField]
    Transform playerTransform;
    [SerializeField]
    Material grassMat;

    Vector3 myPos;
    void Update()
    {
        myPos = playerTransform.position;
        grassMat.SetVector("_PlayerPos", myPos);

        //Debug.Log(Vector3.Distance(playerTransform.position, transform.position));
    }
}

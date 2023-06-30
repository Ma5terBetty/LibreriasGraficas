using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ObjectRotator : MonoBehaviour
{
    public float rotationSpeed;
    public Transform pivotObject;
    void Start()
    {
        pivotObject = transform.parent;
    }
    void Update()
    {
        transform.RotateAround(pivotObject.position, new Vector3(1, 0, 0), rotationSpeed * Time.deltaTime);

        //Debug.Log(Vector3.Dot(transform.forward, pivotObject.forward));
    }
}

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class UnlitLightManager : MonoBehaviour
{
    public static UnlitLightManager Instance;
    public Transform lightObject;
    public Vector3 lightDir;
    //public Material[] unlitMaterials;

    public Vector3 LightDirection { get { return lightDir; } }

    private void Awake()
    {
        if (Instance == null)
        {
            Instance = this;
        }
        else
        {
            Destroy(this.gameObject);
        }
    }

    void Start()
    {
        
    }

    void Update()
    {
        lightDir = (transform.position - lightObject.position);

        /*
        if (Vector3.Dot(transform.forward, lightObject.forward) > 0)
        {
            var lightDir = lightObject.position - transform.position;

            for (int i = 0; i < unlitMaterials.Length; i++)
            {
                unlitMaterials[i].SetVector("_LightDir", lightDir);
            }
        }*/
    }
}

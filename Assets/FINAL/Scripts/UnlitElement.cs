using System.Collections;
using System.Collections.Generic;
using UnityEngine;
public class UnlitElement : MonoBehaviour
{
    public Material[] material;

    private void Awake()
    {
        material = GetComponent<MeshRenderer>().materials;
    }

    void Update()
    {
        material[0].SetVector("_LightDir", UnlitLightManager.Instance.LightDirection);
        material[1].SetVector("_LightDir", UnlitLightManager.Instance.LightDirection);        
    }
}

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class XrayCameral : MonoBehaviour
{

    public Transform target;
    public List<Renderer> listLastRender = new List<Renderer>();
    void Start()
    {


    }

    void Update()
    {
        //first,set all hit render value opacity
        for (int i = 0; i < listLastRender.Count; i++)
        {
            TransparencySet(listLastRender[i], 1.0f);
        }
        Vector3 tarDir = (target.position - transform.position).normalized;
        Debug.DrawLine(target.position, transform.position, Color.red);

        float targetDis = Vector3.Distance(target.position, transform.position);
        RaycastHit[] listHitObj = Physics.RaycastAll(transform.position, tarDir, targetDis);
        Debug.Log(listHitObj.Length);
        for (int i = 0; i < listHitObj.Length; i++)
        {
            RaycastHit hit = listHitObj[i];
            if (hit.transform == target.transform)
            {
                continue;
            }
            Renderer renderer = hit.collider.GetComponent<Renderer>();
            listLastRender.Clear();

            if (renderer)
            {
                listLastRender.Add(renderer);
               
                TransparencySet(renderer, 0.1f);
            }
            // 使用 render 去使 MeshRender fasle,使其完全透明
//             foreach (var lastRend in listLastRend)
//             {
//                 lastRend.enabled = false;
//             }
        }

    }

    void TransparencySet(Renderer renderer, float a)
    {
        renderer.material.shader = Shader.Find("ApcShader/OcclusionTransparent");
        renderer.material.color = new Color(renderer.material.color.r, renderer.material.color.g, renderer.material.color.b, a);
    }
}
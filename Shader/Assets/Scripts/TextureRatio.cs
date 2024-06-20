using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;

public class TextureRatio : MonoBehaviour
{
    [SerializeField, Range(0f, 1f)] private float ratio = 0f;

    private MeshRenderer mr = null;

    private void Awake() {
        mr = GetComponent<MeshRenderer>();
    }

    private void Update() {
        mr.material.SetFloat("_ratio", ratio);
        // 쉐이더 코드의 미들네임을 적어줘야함
    }
}

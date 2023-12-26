using UnityEngine;
using UnityEngine.Rendering;

using System;
using System.IO;
using System.Collections.Generic;


using WriteTxtLog;


namespace Shapes.Samples.Circles
{
	
	public class CircleDebugRenderer : MonoBehaviour {
		
		public Color FillColor;
		public string Path;

		[Range(1f, 10f)] public float Radius = 2f;


		 
		private void Update()
		{

			var circleInfo = new CircleInfo
			{
				center = transform.position,
				forward = transform.forward,
				radius = Radius,
				fillColor = FillColor,
				pathShader = Path
			};
			
			
			Circle.Draw(circleInfo);
		}

		// private void Start()
		// {


		// 	var circleInfo = new CircleInfo
		// 	{
		// 		center = transform.position,
		// 		forward = transform.forward,
		// 		radius = Radius,
		// 		fillColor = FillColor
		// 	};

			
		// 	Circle.Draw(circleInfo);

		// 	Debug.Log(Quaternion.identity);

		// }

		void Awake()
		{
			// WriteTxtLogClass.FunctionWrite();
		}

	}
}

using System.Collections.Generic;
using UnityEngine;

namespace Shapes
{
	public class Circle
	{	
		private static Mesh _quadMesh;
		private static Material _material ;
		public static float antiAliasingSmoothing = 1.5f;


		private const string FillColorParam = "_FillColor";
		private const string AASmoothingParam = "_AASmoothing";

		private static MaterialPropertyBlock _materialPropertyBlock;


		static Material GetMaterial(CircleInfo circleInfo)
		{
			
			string pathShader = circleInfo.pathShader;
			var mat = new Material(Shader.Find(pathShader));
			// var mat = new Material(Shader.Find("Hidden/Shapes/Circle"));
		
			if (SystemInfo.supportsInstancing)
			{
				mat.enableInstancing = true;
			}

			_material = mat;

			return mat;
		}
		
		static MaterialPropertyBlock GetMaterialPropertyBlock(CircleInfo circleInfo)
		{
			if (_materialPropertyBlock == null)
			{
				_materialPropertyBlock = new MaterialPropertyBlock();
			}
		
			_materialPropertyBlock.SetColor(FillColorParam,circleInfo.fillColor);
			_materialPropertyBlock.SetFloat(AASmoothingParam,antiAliasingSmoothing);


			return _materialPropertyBlock;
		}



		static Matrix4x4 GetTRSMatrix(CircleInfo circleInfo)
		{
			var rotation = Quaternion.LookRotation(circleInfo.forward);


			return Matrix4x4.TRS(circleInfo.center, rotation, new Vector3(circleInfo.radius, circleInfo.radius, 1f));
			
		}

		public static void Draw(CircleInfo circleInfo)
		{
			var mesh = GetCircleMesh();
			var materialPropertyBlock = GetMaterialPropertyBlock(circleInfo);
			var matrix = GetTRSMatrix(circleInfo);
			var material = GetMaterial(circleInfo);
			
			Graphics.DrawMesh(mesh,matrix,material,0,null,0,materialPropertyBlock);
		}

		
		static Mesh GetCircleMesh()
		{
			if (_quadMesh != null)
			{
				return _quadMesh;
			}

			_quadMesh = CreateQuadMesh();

			return _quadMesh;
		}
	
		private static Mesh CreateQuadMesh()
		{
			var quadMesh = new Mesh();
			quadMesh.SetVertices(new List<Vector3>
			{
				new Vector3(-1f, -1f, 0f),
				new Vector3(1f, -1f, 0f),
				new Vector3(1f, 1f, 0f),
				new Vector3(-1f, 1f, 0f)
			});

			quadMesh.triangles = new[]
			{
				0, 2, 1,
				0, 3, 2
			};

			var uvMin = -1f;
			var uvMax = 1f;
		
			quadMesh.uv = new[]
			{
				new Vector2(uvMin, uvMin),
				new Vector2(uvMax, uvMin),
				new Vector2(uvMax, uvMax),
				new Vector2(uvMin, uvMax)
			};

			return quadMesh;
		}
	}
}

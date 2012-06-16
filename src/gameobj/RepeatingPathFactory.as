package gameobj
{
	import com.yogurt3d.core.sceneobjects.SceneObject;
	import com.yogurt3d.core.sceneobjects.SceneObjectRenderable;
	import com.yogurt3d.presets.material.MaterialFill;
	
	import managers.ResourcesManager;

	public class RepeatingPathFactory
	{
		private static var m_testMaterial:MaterialFill = new MaterialFill( 0xCC0000 );
		
		
		private static var assetCounter:uint = 0;
		
		private static var m_recycleQueue:Vector.<SceneObject> = new Vector.<SceneObject>();
		
		public static function instantiateRepeatingPathFactory():SceneObject
		{
			if( m_recycleQueue.length > 0 )
			{
				/// Reuse
				return m_recycleQueue.pop()
				
			}else
			{
				/// Create New
				var sc:SceneObject = new SceneObject();
				sc.userID = "path_" + ++assetCounter;
				
				/// Visuals
				var ground:SceneObjectRenderable = new SceneObjectRenderable();
				ground.geometry = ResourcesManager.FLOOR_MESH;
				ground.material = m_testMaterial;
				
				sc.addChild( ground );
				
				return sc;
			}
			
			
		}
		
		public static function recycle( sceneObj:SceneObject ):void
		{
			sceneObj.parent.removeChild( sceneObj );
			
			sceneObj.transformation.matrixGlobal.identity(); /// Remove position data
			
			m_recycleQueue.push( sceneObj );
		}
		
	}
}
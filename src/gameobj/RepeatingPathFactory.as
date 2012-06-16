package gameobj
{
	import com.yogurt3d.core.materials.Material;
	import com.yogurt3d.core.sceneobjects.SceneObject;
	import com.yogurt3d.core.sceneobjects.SceneObjectRenderable;
	import com.yogurt3d.presets.material.MaterialFill;
	import com.yogurt3d.presets.material.MaterialTexture;
	
	import gameobj.controller.RepeatingPathController;
	
	import managers.ResourcesManager;

	public class RepeatingPathFactory
	{
		private static var m_testMaterial:MaterialFill = new MaterialFill( 0xAA0000 );
		private static var m_testMaterial2:MaterialFill = new MaterialFill( 0xFF0000 );
		private static var m_street1Material:MaterialTexture = new MaterialTexture( ResourcesManager.STREET1_TEXTURE );
		private static var m_floorMaterial:MaterialTexture = new MaterialTexture( ResourcesManager.FLOOR_TEXTURE );
		
		private static var assetCounter:uint = 0;
		
//		private static var m_recycleQueue:Vector.<SceneObject> = new Vector.<SceneObject>();
		
		public static function instantiateRepeatingPath():SceneObject
		{
//			if( m_recycleQueue.length > 0 )
//			{
//				/// Reuse
//				var sceneObj
//				return 
//				
//			}else
//			{
				/// Create New
				var sc:SceneObject = new SceneObject();
				sc.userID = "path_" + ++assetCounter;
				sc.addComponent( "repeatingPathController", RepeatingPathController );
				
				/// Visuals
				var ground:SceneObjectRenderable = new SceneObjectRenderable();
				ground.geometry = ResourcesManager.FLOOR_MESH;
				ground.material = m_floorMaterial;
				
				sc.addChild( ground );
				
				var house:SceneObjectRenderable = new SceneObjectRenderable();
				house.geometry = ResourcesManager.STREET1_MESH;
				house.material = m_street1Material;
				
				sc.addChild( house );
				
				return sc;
//			}
			
			
		}
		
//		public static function recycle( sceneObj:SceneObject ):void
//		{
//			sceneObj.parent.removeChild( sceneObj );
//			sceneObj.removeAllComponents();
//			
//			sceneObj.transformation.matrixGlobal.identity(); /// Remove position data
//			
//			m_recycleQueue.push( sceneObj );
//		}
		
	}
}
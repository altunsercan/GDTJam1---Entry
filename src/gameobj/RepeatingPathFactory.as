package gameobj
{
	import com.yogurt3d.core.sceneobjects.SceneObject;
	import com.yogurt3d.core.sceneobjects.SceneObjectRenderable;
	import com.yogurt3d.presets.material.MaterialFill;
	
	import gameobj.controller.RepeatingPathController;
	
	import managers.ResourcesManager;

	public class RepeatingPathFactory
	{
		private static var m_testMaterial:MaterialFill = new MaterialFill( 0xCC0000, 0.7 );
		
		
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
				ground.material = m_testMaterial;
				
				sc.addChild( ground );
				
				var house:SceneObjectRenderable = new SceneObjectRenderable();
				house.geometry = ResourcesManager.HOUSE_MESH;
				house.material = m_testMaterial;
				
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
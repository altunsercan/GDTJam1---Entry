package gameobj
{
	import com.yogurt3d.core.sceneobjects.SceneObject;
	import com.yogurt3d.core.sceneobjects.SceneObjectRenderable;
	import com.yogurt3d.presets.geometry.BoxMesh;
	import com.yogurt3d.presets.material.MaterialFill;
	
	import managers.ResourcesManager;

	public class SnakeFactory
	{
		private static var m_testMaterial:MaterialFill = new MaterialFill( 0x00CC00 );
		
		private static var assetCounter:uint = 0;
		
		private static var m_recycleQueue:Vector.<SceneObject> = new Vector.<SceneObject>();
		
		public static function instantiateSnake():SceneObject
		{
			if( m_recycleQueue.length > 0 )
			{
				/// Reuse
				return m_recycleQueue.pop();
				
			}else
			{
			
				var sc:SceneObject = new SceneObject();
				sc.userID = "snake_"+ ++assetCounter;
				
				/// Visual
				var visual:SceneObjectRenderable = new SceneObjectRenderable();
				visual.geometry = ResourcesManager.SNAKE_MESH
				visual.material = m_testMaterial;
				visual.transformation.y = 0.25; /// Shift up to keep y as 0 in parent position
				
				sc.addChild( visual );
				
				return sc;
			}
		}
		public static function recycle( sceneObj:SceneObject ):void
		{
			if( sceneObj.parent)
				sceneObj.parent.removeChild( sceneObj );
			
			sceneObj.transformation.matrixGlobal.identity(); /// Remove position data
			
			m_recycleQueue.push( sceneObj );
		}
		
	}
}
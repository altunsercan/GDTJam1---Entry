package gameobj
{
	import com.yogurt3d.core.sceneobjects.SceneObject;
	import com.yogurt3d.core.sceneobjects.SceneObjectRenderable;
	import com.yogurt3d.presets.geometry.BoxMesh;
	import com.yogurt3d.presets.material.MaterialFill;
	import com.yogurt3d.presets.material.MaterialTexture;
	
	import gameobj.controller.CowController;
	
	import managers.ResourcesManager;

	public class CowFactory
	{
		private static var m_cowMaterial:MaterialTexture = new MaterialTexture( ResourcesManager.COW_TEXTURE );
		
		private static var assetCounter:uint = 0;
		
		private static var m_recycleQueue:Vector.<SceneObject> = new Vector.<SceneObject>();
		
		public static function instantiateCow():SceneObject
		{
			if( m_recycleQueue.length > 0 )
			{
				/// Reuse
				return m_recycleQueue.pop();
				
			}else
			{
			
				var sc:SceneObject = new SceneObject();
				sc.userID = "cow_"+ ++assetCounter;
				
				sc.addComponent("cowController", CowController );
				
				/// Visual
				var visual:SceneObjectRenderable = new SceneObjectRenderable();
				visual.geometry = ResourcesManager.COW_MESH;
				visual.material = m_cowMaterial;
				
				
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
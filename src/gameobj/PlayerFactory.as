package gameobj
{
	import com.yogurt3d.core.materials.Material;
	import com.yogurt3d.core.sceneobjects.SceneObject;
	import com.yogurt3d.core.sceneobjects.SceneObjectRenderable;
	import com.yogurt3d.presets.geometry.BoxMesh;
	import com.yogurt3d.presets.material.MaterialFill;
	
	import gameobj.controller.PlayerController;

	public class PlayerFactory
	{
		public static function instantiatePlayer():SceneObject
		{
			var sc:SceneObject = new SceneObject();
			sc.userID = "player";
			sc.addComponent("playerController", PlayerController );
			
			/// Visual
			var visual:SceneObjectRenderable = new SceneObjectRenderable();
			visual.userID = "playerVisual";
			visual.geometry = new BoxMesh( 0.5, 1, 0.5 );
			visual.material = new MaterialFill( 0x0000CC );
			visual.transformation.y = 5; /// Shift up to keep y as 0 in parent position
			
			sc.addChild( visual );
			
			return sc;
		}
	}
}
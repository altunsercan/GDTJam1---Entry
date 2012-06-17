package gameobj
{
	import com.yogurt3d.core.animation.controllers.SkinController;
	import com.yogurt3d.core.geoms.SkeletalAnimatedMesh;
	import com.yogurt3d.core.materials.Material;
	import com.yogurt3d.core.sceneobjects.SceneObject;
	import com.yogurt3d.core.sceneobjects.SceneObjectRenderable;
	import com.yogurt3d.io.parsers.Y3D_Parser;
	import com.yogurt3d.presets.geometry.BoxMesh;
	import com.yogurt3d.presets.material.MaterialFill;
	import com.yogurt3d.presets.material.MaterialTexture;
	
	import gameobj.controller.PlayerController;
	
	import managers.ResourcesManager;

	public class PlayerFactory
	{
		public static function instantiatePlayer():SceneObject
		{
			var sc:SceneObject = new SceneObject();
			sc.userID = "snake_";
			sc.addComponent("playerController", PlayerController );
			
			/// Visual
			var visual:SceneObjectRenderable = new SceneObjectRenderable();
			visual.userID = "playerVisual";
			visual.geometry = ResourcesManager.PLAYER_MESH;
			var animCont:SkinController = SkinController( visual.geometry.getComponent("skinController"));
			animCont.addAnimation( "run", ResourcesManager.PLAYER_ANIM );
			animCont.playAnimation("run");
			visual.material = new MaterialTexture( ResourcesManager.PLAYER_TEXTURE );
			
			var shadow:SceneObjectRenderable = new SceneObjectRenderable();
			shadow.userID = "playerShadow";
			shadow.geometry = ResourcesManager.SHADOW_MESH;
			shadow.material = new MaterialTexture( ResourcesManager.SHADOW_TEXTURE );
			
			var arrow:SceneObjectRenderable = new SceneObjectRenderable();
			arrow.userID = "playerArrow";
			arrow.geometry = ResourcesManager.OK_MESH;
			arrow.material = new MaterialFill( 0x661123 );
			
			sc.addChild( visual );
			sc.addChild( shadow );
			sc.addChild( arrow );
			
			return sc;
		}
	}
}
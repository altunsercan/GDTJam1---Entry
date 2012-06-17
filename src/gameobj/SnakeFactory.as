package gameobj
{
	import com.yogurt3d.core.animation.controllers.SkinController;
	import com.yogurt3d.core.animation.event.AnimationEvent;
	import com.yogurt3d.core.geoms.Mesh;
	import com.yogurt3d.core.geoms.SkeletalAnimatedMesh;
	import com.yogurt3d.core.sceneobjects.SceneObject;
	import com.yogurt3d.core.sceneobjects.SceneObjectRenderable;
	import com.yogurt3d.presets.geometry.BoxMesh;
	import com.yogurt3d.presets.material.MaterialFill;
	import com.yogurt3d.presets.material.MaterialTexture;
	
	import flash.geom.Vector3D;
	
	import gameobj.controller.SnakeController;
	
	import managers.ResourcesManager;

	public class SnakeFactory
	{
		private static var m_basketMaterial:MaterialTexture = new MaterialTexture( ResourcesManager.BASKET_TEXTURE );
		private static var m_snakeMaterial:MaterialTexture = new MaterialTexture( ResourcesManager.SNAKE_TEXTURE );
		
		private static var assetCounter:uint = 0;
		
		private static var m_recycleQueue:Vector.<SceneObject> = new Vector.<SceneObject>();
		
		public static function instantiateSnake():SceneObject
		{
			var sc:SceneObject
			if( m_recycleQueue.length > 0 )
			{
				/// Reuse
				sc = m_recycleQueue.pop();
				
				return sc
				
			}else
			{
			
				sc = new SceneObject();
				sc.userID = "snake_"+ ++assetCounter;
				
				sc.addComponent( "snakeController", SnakeController);
				
				/// Visual
				var basket:SceneObjectRenderable = new SceneObjectRenderable();
				basket.geometry = ResourcesManager.BASKET_MESH.instance() as SkeletalAnimatedMesh;
				basket.material = m_basketMaterial;
				var animCont:SkinController = SkinController( basket.geometry.getComponent("skinController"));
				animCont.addAnimation( "basket", ResourcesManager.BASKET_ANIM );
				animCont.playAnimation( "basket", 0 );
				animCont.addFrameEventListener( AnimationEvent.FRAME, function anim1Call( _e:AnimationEvent ):void{
					_e.target.stop();
					SkinController(_e.target).removeFrameEventListener( AnimationEvent.FRAME, anim1Call, 0 );
				}, 0);
				
				
				sc.addChild( basket );
				
				var snake:SceneObjectRenderable = new SceneObjectRenderable();
				snake.geometry = ResourcesManager.SNAKE_MESH.instance() as SkeletalAnimatedMesh;
				snake.material = m_snakeMaterial;
				var animCont2:SkinController = SkinController( snake.geometry.getComponent("skinController"));
				animCont2.addAnimation( "snake", ResourcesManager.SNAKE_ANIM );
				animCont2.playAnimation( "snake", 0 );
				animCont2.addFrameEventListener( AnimationEvent.FRAME, function anim2Call( _e:AnimationEvent ):void{
					_e.target.stop();
					SkinController(_e.target).removeFrameEventListener( AnimationEvent.FRAME, anim2Call, 0 );
				}, 0);
				
				sc.addChild( snake );
				
				return sc;
			}
		}
		public static function recycle( sceneObj:SceneObject ):void
		{
			if( sceneObj.parent)
				sceneObj.parent.removeChild( sceneObj );
			
			sceneObj.transformation.position = new Vector3D( -50, 0, 0 );; /// Remove position data
			
			
			m_recycleQueue.push( sceneObj );
		}
		
	}
}
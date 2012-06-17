package managers
{
	import com.yogurt3d.core.animation.SkeletalAnimationData;
	import com.yogurt3d.core.geoms.Mesh;
	import com.yogurt3d.core.geoms.SkeletalAnimatedMesh;
	import com.yogurt3d.core.texture.TextureMap;
	import com.yogurt3d.io.loaders.DataLoader;
	import com.yogurt3d.io.loaders.DisplayObjectLoader;
	import com.yogurt3d.io.managers.loadmanagers.LoadManager;
	import com.yogurt3d.io.managers.loadmanagers.LoaderEvent;
	import com.yogurt3d.io.parsers.TextureMap_Parser;
	import com.yogurt3d.io.parsers.Y3D_Parser;
	import com.yogurt3d.io.parsers.YOA_Parser;
	
	import flash.utils.ByteArray;
	
	import org.osflash.signals.Signal;

	public class ResourcesManager
	{
		public static var PLAYER_MESH:SkeletalAnimatedMesh; // y3d is not ready at this stage
		public static var RUN_ANIM:SkeletalAnimationData;
		public static var DASH_ANIM:SkeletalAnimationData;
		public static var RUNFAST_ANIM:SkeletalAnimationData;
		public static var SNAKE_ANIM:SkeletalAnimationData;
		public static var BASKET_ANIM:SkeletalAnimationData;
		
		public static var FLOOR_MESH:Mesh;
		public static var STREET1_MESH:Mesh;
		public static var COW_MESH:Mesh;
		public static var BASKET_MESH:SkeletalAnimatedMesh;
		public static var SNAKE_MESH:SkeletalAnimatedMesh;
		public static var SHADOW_MESH:Mesh;
		public static var OK_MESH:Mesh;
		
		public static var PLAYER_TEXTURE:TextureMap;
		public static var STREET1_TEXTURE:TextureMap;
		public static var FLOOR_TEXTURE:TextureMap;
		public static var SHADOW_TEXTURE:TextureMap;
		public static var BASKET_TEXTURE:TextureMap;
		public static var SNAKE_TEXTURE:TextureMap;
		public static var COW_TEXTURE:TextureMap;
		
		private var m_loadManager:LoadManager
		
		public var PROGRESS:Signal = new Signal( Number ); /// loaded ratio
		public var COMPLETE:Signal = new Signal();
		
		public var complete:Boolean = false;
		public function ResourcesManager()
		{
		}
		
		public function loadResources():void
		{
			m_loadManager = new LoadManager();
//			m_loadManager.addEventListener(LoaderEvent.FILE_COMPLETE, onFileComplete );
			m_loadManager.addEventListener(LoaderEvent.ALL_COMPLETE, onAllComplete );
			m_loadManager.addEventListener(LoaderEvent.LOAD_PROGRESS, onLoadProgress );
			// Add resources
			m_loadManager.add( "resources/yoa/run.yoa", 	DataLoader, YOA_Parser );
			m_loadManager.add( "resources/yoa/dash.yoa", 	DataLoader, YOA_Parser );
			m_loadManager.add( "resources/yoa/runFast.yoa", 	DataLoader, YOA_Parser );
			m_loadManager.add( "resources/yoa/yilan.yoa", 	DataLoader, YOA_Parser );
			m_loadManager.add( "resources/yoa/sepet.yoa", 	DataLoader, YOA_Parser );
			
			m_loadManager.add( "resources/y3d/sikh.y3d", 	DataLoader, Y3D_Parser );
			m_loadManager.add( "resources/y3d/zemin.y3d", 	DataLoader, Y3D_Parser);
			m_loadManager.add( "resources/y3d/sokak1.y3d", 	DataLoader, Y3D_Parser );
			m_loadManager.add( "resources/y3d/inek.y3d", 	DataLoader, Y3D_Parser );
			m_loadManager.add( "resources/y3d/sepet.y3d", 	DataLoader, Y3D_Parser );
			m_loadManager.add( "resources/y3d/shadow.y3d", 	DataLoader, Y3D_Parser );
			m_loadManager.add( "resources/y3d/OK.y3d", 		DataLoader, Y3D_Parser );
			m_loadManager.add( "resources/y3d/yilan.y3d", 	DataLoader, Y3D_Parser );
			
			m_loadManager.add( "resources/texture/sikh.jpg", 	DisplayObjectLoader, TextureMap_Parser, null, true );
			m_loadManager.add( "resources/texture/sokak1.jpg", 	DisplayObjectLoader, TextureMap_Parser, null, true );
			m_loadManager.add( "resources/texture/zemin.jpg", 	DisplayObjectLoader, TextureMap_Parser, null, true );
			m_loadManager.add( "resources/texture/shadow.png", 	DisplayObjectLoader, TextureMap_Parser, null, true );
			m_loadManager.add( "resources/texture/sepet.jpg", 	DisplayObjectLoader, TextureMap_Parser, null, true );
			m_loadManager.add( "resources/texture/yilan.jpg", 	DisplayObjectLoader, TextureMap_Parser, null, true );
			m_loadManager.add( "resources/texture/inek.jpg", 	DisplayObjectLoader, TextureMap_Parser, null, true );
			m_loadManager.add( "resources/texture/yilan.jpg", 	DisplayObjectLoader, TextureMap_Parser, null, true );
			
			m_loadManager.start();
		}
		
//		private function onFileComplete( _e:LoaderEvent ):void
//		{
//		}
		private function onAllComplete( _e:LoaderEvent ):void
		{
			PLAYER_MESH = 		m_loadManager.getLoadedContent( "resources/y3d/sikh.y3d" );
			RUN_ANIM = 			m_loadManager.getLoadedContent( "resources/yoa/run.yoa" );
			PLAYER_TEXTURE=		m_loadManager.getLoadedContent( "resources/texture/sikh.jpg" );
			DASH_ANIM = 		m_loadManager.getLoadedContent( "resources/yoa/dash.yoa" );
			RUNFAST_ANIM = 		m_loadManager.getLoadedContent( "resources/yoa/runFast.yoa" );
			SNAKE_ANIM = 		m_loadManager.getLoadedContent( "resources/yoa/yilan.yoa" );
			BASKET_ANIM = 		m_loadManager.getLoadedContent( "resources/yoa/sepet.yoa" );
			
			FLOOR_MESH = 		m_loadManager.getLoadedContent( "resources/y3d/zemin.y3d" );
			STREET1_MESH = 		m_loadManager.getLoadedContent( "resources/y3d/sokak1.y3d" );
			COW_MESH = 			m_loadManager.getLoadedContent( "resources/y3d/inek.y3d" );
			BASKET_MESH = 		m_loadManager.getLoadedContent( "resources/y3d/sepet.y3d" );
			SNAKE_MESH = 		m_loadManager.getLoadedContent( "resources/y3d/yilan.y3d" );
			SHADOW_MESH = 		m_loadManager.getLoadedContent( "resources/y3d/shadow.y3d" );
			OK_MESH =	 		m_loadManager.getLoadedContent( "resources/y3d/OK.y3d" );
			
			STREET1_TEXTURE =	m_loadManager.getLoadedContent( "resources/texture/sokak1.jpg" );
			FLOOR_TEXTURE	= 	m_loadManager.getLoadedContent( "resources/texture/zemin.jpg" );
			SHADOW_TEXTURE  =	m_loadManager.getLoadedContent( "resources/texture/shadow.png" );
			BASKET_TEXTURE  =	m_loadManager.getLoadedContent( "resources/texture/sepet.jpg" );
			SNAKE_TEXTURE	=	m_loadManager.getLoadedContent( "resources/texture/yilan.jpg" );
			COW_TEXTURE     =	m_loadManager.getLoadedContent( "resources/texture/inek.jpg" );
			
			complete = true;
			
			COMPLETE.dispatch();
		}
		private function onLoadProgress( _e:LoaderEvent ):void
		{
			PROGRESS.dispatch( m_loadManager.loadRatio );
		}
	}
}
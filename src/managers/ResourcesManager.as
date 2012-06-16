package managers
{
	import com.yogurt3d.core.geoms.Mesh;
	import com.yogurt3d.io.loaders.DataLoader;
	import com.yogurt3d.io.managers.loadmanagers.LoadManager;
	import com.yogurt3d.io.managers.loadmanagers.LoaderEvent;
	import com.yogurt3d.io.parsers.Y3D_Parser;
	
	import org.osflash.signals.Signal;

	public class ResourcesManager
	{
		public static var FLOOR_MESH:Mesh;
		public static var HOUSE_MESH:Mesh;
		public static var COW_MESH:Mesh;
		public static var SNAKE_MESH:Mesh;
		public static var TENT_MESH:Mesh;
		
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
			m_loadManager.add( "resources/y3d/zemin.y3d", 	DataLoader, Y3D_Parser);
			m_loadManager.add( "resources/y3d/ev.y3d", 		DataLoader, Y3D_Parser );
			m_loadManager.add( "resources/y3d/inek.y3d", 	DataLoader, Y3D_Parser );
			m_loadManager.add( "resources/y3d/yilan.y3d", 	DataLoader, Y3D_Parser );
			m_loadManager.add( "resources/y3d/cadir.y3d", 	DataLoader, Y3D_Parser );
			
			m_loadManager.start();
		}
		
//		private function onFileComplete( _e:LoaderEvent ):void
//		{
//		}
		private function onAllComplete( _e:LoaderEvent ):void
		{
			FLOOR_MESH = m_loadManager	.getLoadedContent( "resources/y3d/zemin.y3d" );
			HOUSE_MESH = m_loadManager	.getLoadedContent( "resources/y3d/ev.y3d" );
			COW_MESH = m_loadManager	.getLoadedContent( "resources/y3d/inek.y3d" );
			SNAKE_MESH = m_loadManager	.getLoadedContent( "resources/y3d/yilan.y3d" );
			TENT_MESH = m_loadManager	.getLoadedContent( "resources/y3d/cadir.y3d" );
			
			complete = true;
			
			COMPLETE.dispatch();
		}
		private function onLoadProgress( _e:LoaderEvent ):void
		{
			PROGRESS.dispatch( m_loadManager.loadRatio );
		}
	}
}
package screens
{
	import com.yogurt3d.core.viewports.Viewport;
	
	import flash.display.Sprite;
	
	public class GameScreen extends Sprite implements IScreen
	{
		private var m_viewport:Viewport;
		public function GameScreen()
		{
			super();
		}
		
		public function addViewport( view:Viewport ):void
		{
			m_viewport = view;	
			
			addChildAt( view, 0 );
		
		}
		
		public function show():void
		{
			m_viewport.update();
		}
		
		public function hide():void
		{
		}
		
		public function destroyScreen():void
		{
		}
	}
}
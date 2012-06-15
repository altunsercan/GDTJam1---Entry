package managers
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.utils.Dictionary;
	
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	
	import screens.IScreen;

	public class ScreenManager
	{
		private var m_screens:Dictionary;
		private var m_logger:ILogger;
		private var m_currentScreen:String;
		
		
		[Inject]
		public var stage:GDTJam1; 
		
		public function ScreenManager()
		{
			m_logger = getLogger( ScreenManager );
			m_screens = new Dictionary();
		}
		
		public function addScreen( screenName:String, screen:IScreen, changeToScreen:Boolean = false ):void
		{
			if( m_screens[ screenName ] != null )
			{
				m_logger.warn( "Overriding screen named: "+ screenName );
				destroyScreen( screenName );
			}
			m_screens[screenName] = screen;
			if( changeToScreen )
			{
				changeScreen( screenName );
			}
		}
		
		public function changeScreen( screenName:String ):void
		{
			if( screenName != m_currentScreen )
			{
				if( m_currentScreen )
				{
					var oldScreen:IScreen = m_screens[m_currentScreen];
					oldScreen.hide();
					stage.removeChild( DisplayObject(oldScreen));
				}
				
				if( screenName != null )
				{
					var newScreen:IScreen = m_screens[screenName];
					if( newScreen != null )
					{
						stage.addChild( DisplayObject(newScreen) );
						newScreen.show();
					}
				}
				
			}
		}
		
		
		public function getScreen( screenName:String ):IScreen
		{
			if( m_screens[screenName] != null )
			{
				return IScreen(m_screens[screenName]);
			}
			return null;
		}
		
		public function destroyScreen( screenName:String ):void
		{
			var screen:IScreen = m_screens[screenName ];
			if( screenName == m_currentScreen )
			{
				changeScreen( null );
			}
			screen.destroyScreen();
			delete m_screens[screenName ];
		}
		
	}
}
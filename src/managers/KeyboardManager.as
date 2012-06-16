package managers
{
	import com.yogurt3d.Yogurt3D;
	
	import flash.events.KeyboardEvent;
	import flash.utils.Dictionary;

	public class KeyboardManager
	{
		[Inject]
		public var screenManager:ScreenManager;
		
		private var keyDownMap:Dictionary;
		private var keyJustDownArr:Array;
		private var keyJustUpArr:Array;
		public function KeyboardManager()
		{
		}
		
		public function initialize():void
		{
			keyDownMap = new Dictionary();
			
			keyJustDownArr = new Array();
			keyJustUpArr = new Array();
			
			screenManager.stage.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDownX);
			screenManager.stage.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			
			Yogurt3D.onFrameEnd.add( onFrameEnd );
		}
		private function onFrameEnd():void
		{
			if( keyJustDownArr.length > 0 )
			{
				keyJustDownArr = [];
			}
			if( keyJustUpArr.length > 0 )
			{
				keyJustUpArr = [];
			}
			
		}
		
		public function isKeyDown( keyCode:uint ):Boolean
		{
			if(  keyDownMap[ keyCode ] == null )
			{
				return false;
			}
			return keyDownMap[ keyCode ]  ;
		}
		
		public function isKeyJustDown( keyCode:uint ):Boolean
		{
			return keyJustDownArr.indexOf( keyCode ) != -1;
		}
		
		public function isKeyJustUp( keyCode:uint ):Boolean
		{
			return keyJustUpArr.indexOf( keyCode ) != -1;
		}
		
		private function onKeyDownX( _e:KeyboardEvent ):void
		{
			var currentValue:Boolean;
			if(  keyDownMap[ _e.keyCode ] == null )
			{
				currentValue = false;
			}else
			{
				currentValue =  keyDownMap[ _e.keyCode ]  ;
			}
			
			if( currentValue == false )
			{
				keyJustDownArr.push(  _e.keyCode );
				keyDownMap[ _e.keyCode ] = true;
			}
			
		}
		private function onKeyUp( _e:KeyboardEvent ):void
		{
			var currentValue:Boolean;
			if(  keyDownMap[ _e.keyCode ] == null )
			{
				currentValue = true;
			}else
			{
				currentValue =  keyDownMap[ _e.keyCode ]  ;
			}
			
			if( currentValue == true )
			{
				keyJustUpArr.push(  _e.keyCode );
				keyDownMap[ _e.keyCode ] = false;
			}
		}
	}
}
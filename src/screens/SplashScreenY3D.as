package screens
{
	import com.greensock.TweenNano;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	import org.osflash.signals.Signal;
	
	public class SplashScreenY3D extends Sprite implements IScreen
	{
//		[Embed(source="resources/splash/poweredbyyogurt3d.png")]
//		private const Y3D_LOGO:Class;
//		
		
		[Embed("resources/splash/intro.swf")]
		private var SWFClass:Class;
		
		
//		private const FADEIN:Number = 2;
//		private const DISPLAY:Number = 2;
//		private const FADEOUT:Number = 2;
		
		public const SPLASH_COMPLETE:Signal = new Signal(); 
		
		
		private var m_preLoader:MovieClip;
		
		private var m_initialized:Boolean = false;
		
		public function SplashScreenY3D()
		{
			super();
			
			
			
		}
		
		public function show():void
		{
			if( !m_initialized )
			{
				initializeLazy();
			}
			
			var timer:Timer = new Timer(10000 );
			timer.addEventListener(TimerEvent.TIMER, onTimerComplete);
			
			timer.start();
			
//			TweenNano.to( this, FADEIN, {alpha:1} );
//			TweenNano.to( this, FADEOUT, {alpha:0, delay:FADEIN+DISPLAY, onComplete:onFadeOutComplete, overwrite:false} );
		}
		
		private function onTimerComplete( _e:TimerEvent ):void
		{
			Timer(_e.target).removeEventListener( TimerEvent.TIMER_COMPLETE, onTimerComplete );
			SPLASH_COMPLETE.dispatch();
		}
		
		private function initializeLazy():void
		{
//			this.alpha = 0;
			
//			var logo:Bitmap = new Y3D_LOGO();
//			//logo.height = 100;
//			logo.x = GDTJam1.width / 2 - logo.width / 2 - 64;
//			logo.y = GDTJam1.height - 100;
//			
//			var sercanField:TextField = new TextField();
//			sercanField.textColor = 0xF0F0F0;
//			sercanField.text = "Code: Sercan Altun";
//			sercanField.x = GDTJam1.width / 2 - logo.width / 2 - 200
//			sercanField.y = GDTJam1.height - 150;
//			this.addChild( sercanField );
//			
//			var meteField:TextField = new TextField();
//			meteField.text = "Art: Mete Fisunoğlu";
//			meteField.textColor = 0xF0F0F0;
//			meteField.x = GDTJam1.width / 2 - logo.width / 2 + 200
//			meteField.y = GDTJam1.height - 150;
//			this.addChild( meteField );
//			
//			this.addChild( logo );
			
			m_preLoader = MovieClip(new SWFClass());
			
			this.addChild(m_preLoader);
			
			m_preLoader.play();
			
			//SPLASH_COMPLETE.dispatch();
		}
		
		public function onFadeOutComplete():void
		{
			SPLASH_COMPLETE.dispatch();
		}
		
		public function hide():void
		{
			this.alpha = 0;
			
		}
		
		public function destroyScreen():void
		{
			while( this.numChildren > 0 )
				this.removeChildAt(0);
			
		}
		
	}
}
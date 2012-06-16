package screens
{
	import com.greensock.TweenNano;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	import org.osflash.signals.Signal;
	
	public class SplashScreenY3D extends Sprite implements IScreen
	{
		[Embed(source="resources/splash/poweredbyyogurt3d.png")]
		private const Y3D_LOGO:Class;
		
		private const FADEIN:Number = 2;
		private const DISPLAY:Number = 2;
		private const FADEOUT:Number = 2;
		
		public const SPLASH_COMPLETE:Signal = new Signal(); 
		
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
			
			TweenNano.to( this, FADEIN, {alpha:1} );
			TweenNano.to( this, FADEOUT, {alpha:0, delay:FADEIN+DISPLAY, onComplete:onFadeOutComplete, overwrite:false} );
		}
		
		private function initializeLazy():void
		{
			this.alpha = 0;
			
			var logo:Bitmap = new Y3D_LOGO();
			//logo.height = 100;
			logo.x = GDTJam1.width / 2 - logo.width / 2;
			logo.y = GDTJam1.height - 100;
			
			this.addChild( logo );
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
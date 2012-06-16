package cmd
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import managers.ResourcesManager;
	
	import org.as3commons.async.command.IAsyncCommand;
	
	public class LoadGameAssetsCmd extends EventDispatcher implements IAsyncCommand
	{
		[Inject]
		public var resourceManager:ResourcesManager;
		
		public function LoadGameAssetsCmd(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function execute():*
		{
			GDTJam1.masterInjector.injectInto( this );
			
			resourceManager.loadResources();
			
			
			return null;
		}
		
		public function get result():*
		{
			return null;
		}
		
		public function get error():*
		{
			return null;
		}
		
		public function get timeout():int
		{
			return 0;
		}
		
		public function set timeout(value:int):void
		{
		}
		
		public function addCompleteListener(listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
		}
		
		public function addErrorListener(listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
		}
		
		public function addTimeoutListener(listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
		}
		
		public function removeCompleteListener(listener:Function, useCapture:Boolean=false):void
		{
		}
		
		public function removeErrorListener(listener:Function, useCapture:Boolean=false):void
		{
		}
		
		public function removeTimeoutListener(listener:Function, useCapture:Boolean=false):void
		{
		}
	}
}
package cmd
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import managers.ResourcesManager;
	
	import org.as3commons.async.command.IAsyncCommand;
	import org.as3commons.async.operation.event.OperationEvent;
	
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
			
			resourceManager.COMPLETE.addOnce( onResourcesLoaded );
			resourceManager.loadResources();
			
			return null;
		}
		
		public function onResourcesLoaded():void
		{
			var event:OperationEvent = new OperationEvent( OperationEvent.COMPLETE, this );
			dispatchEvent( event );
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
			addEventListener(OperationEvent.COMPLETE, listener, useCapture, priority, useWeakReference);
		}
		
		public function addErrorListener(listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			addEventListener(OperationEvent.ERROR, listener, useCapture, priority, useWeakReference);
		}
		
		public function addTimeoutListener(listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			addEventListener(OperationEvent.TIMEOUT, listener, useCapture, priority, useWeakReference);
		}
		
		public function removeCompleteListener(listener:Function, useCapture:Boolean=false):void
		{
			removeEventListener(OperationEvent.COMPLETE, listener, useCapture);
		}
		
		public function removeErrorListener(listener:Function, useCapture:Boolean=false):void
		{
			removeEventListener(OperationEvent.ERROR, listener, useCapture);
		}
		
		public function removeTimeoutListener(listener:Function, useCapture:Boolean=false):void
		{
			removeEventListener(OperationEvent.TIMEOUT, listener, useCapture);
		}
	}
}
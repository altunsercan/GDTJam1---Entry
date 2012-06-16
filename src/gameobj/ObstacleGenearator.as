package gameobj
{
	import com.yogurt3d.Yogurt3D;
	import com.yogurt3d.core.sceneobjects.Scene;
	import com.yogurt3d.core.sceneobjects.SceneObject;
	
	import flash.utils.Dictionary;
	
	import gameobj.controller.ObstacleController;
	
	import managers.Y3DManager;
	
	import org.as3commons.logging.util.xml.xmlNs;

	public class ObstacleGenearator
	{
		private const OBS_SNAKE:uint = 1;
		
		private var obstacleTemplatesByDifficulty:Dictionary;
		
		private var minPrefetchObstacleLength:Number = 30;
		private var startOffset:Number = 48;
		private var m_obstaclesInScene:Vector.<SceneObject>;
		private var m_currentObsticleLen:Number = 0;
		
		[Inject]
		public var y3dManager:Y3DManager;
		
		public function ObstacleGenearator()
		{
			
			//GDTJam1.masterInjector.injectInto( this );
			
		}
		public function initObstacles():void
		{
			m_obstaclesInScene = new Vector.<SceneObject>();
			obstacleTemplatesByDifficulty = new Dictionary();
			
			var obstacleTemplates:Vector.<ObstacleTemplate>;
			
			var obstacleTemp:ObstacleTemplate;
			
			/// Difficulty 0 templates
			obstacleTemplatesByDifficulty["0"] = obstacleTemplates = new Vector.<ObstacleTemplate>();
			
			obstacleTemp = new ObstacleTemplate();
			obstacleTemp.obstacleLength = 10;
			obstacleTemp.obstacleItemList.push( {type:OBS_SNAKE,  x: 6, z:0 } );
			obstacleTemplates.push( obstacleTemp );
			
			obstacleTemp = new ObstacleTemplate();
			obstacleTemp.obstacleLength = 15;
			obstacleTemp.obstacleItemList.push( {type:OBS_SNAKE,  x: 12, z:-4 } );
			obstacleTemp.obstacleItemList.push( {type:OBS_SNAKE,  x: 8, z:4 } );
			obstacleTemplates.push( obstacleTemp );
		}
		
		public function start( ):void
		{
			/// put first 
			
			var template:ObstacleTemplate = getRandomObstacleTemplate();
			var obstacle:SceneObject = createObstacle( template );
			obstacle.transformation.x = startOffset;
			
			y3dManager.scene.addChild( obstacle );
			m_obstaclesInScene.push( obstacle );
			
			m_currentObsticleLen += template.obstacleLength;
			
//			var positionNumber:Number = startOffset;
//			/// create obstacles to the need 			
//			while( m_currentObsticleLen < minPrefetchObstacleLength )
//			{
//				var template:ObstacleTemplate = getRandomObstacleTemplate();
//				
//				var obstacle:SceneObject = createObstacle( template );
//				obstacle.transformation.x = positionNumber;
//				
//				y3dManager.scene.addChild( obstacle );
//				m_obstaclesInScene.push( obstacle );
//				
//				positionNumber += template.obstacleLength;
//				m_currentObsticleLen += template.obstacleLength;
//				
//			}
			
			Yogurt3D.onFrameStart.add( onUpdate );
			
		}
		
		public function notifyRemove( obs:ObstacleController ):void
		{
			m_currentObsticleLen -= obs.len;
			m_obstaclesInScene.shift();
		}
		
		
		private function onUpdate( ):void
		{
			var obsticleTail:Number;
			
			if(m_obstaclesInScene.length >0 )
			{
				obsticleTail = m_obstaclesInScene[0].transformation.x + m_currentObsticleLen;
			}else
			{
				obsticleTail = startOffset-1;
			}
				
				
			
			if( obsticleTail  < startOffset )
			{
				while(obsticleTail < minPrefetchObstacleLength )
				{
					var template:ObstacleTemplate = getRandomObstacleTemplate();
					
					var obstacle:SceneObject = createObstacle( template );
					obstacle.transformation.x = obsticleTail;
					
					y3dManager.scene.addChild( obstacle );
					m_obstaclesInScene.push( obstacle );
					
					obsticleTail += template.obstacleLength;
					m_currentObsticleLen += template.obstacleLength;
				}
			}
		}
		
		private function getRandomObstacleTemplate():ObstacleTemplate
		{
			var difficulty:Number = 0; // TODO: Multiple Difficulties
			var obsList:Vector.<ObstacleTemplate> = obstacleTemplatesByDifficulty[ ""+difficulty ];
			var obsIndex:int = Math.round( Math.random() * (obsList.length - 1) );
			
			return obsList[ obsIndex ];
		}
		
		private function createObstacle( obsTemplate:ObstacleTemplate ):SceneObject
		{
			var sc:SceneObject = new SceneObject();
			for each( var obj:Object in obsTemplate.obstacleItemList )
			{
				var obs:SceneObject;
				
				switch( obj.type )
				{
					case OBS_SNAKE:
						obs = SnakeFactory.instantiateSnake();
						break;
				}
				obs.transformation.x = obj.x;
				obs.transformation.z = obj.z;
				sc.addChild(obs);
			}
			
			sc.addComponent("obstacleController", ObstacleController, obsTemplate.obstacleLength );
			
			
			return sc;
		}
	}
}
import com.yogurt3d.core.sceneobjects.SceneObject;

internal class ObstacleTemplate
{
	public var obstacleLength:Number;
	public var obstacleItemList:Array;
	
	public function ObstacleTemplate()
	{
		obstacleItemList = [];
	}
	
	
	
}
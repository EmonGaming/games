package scripts
{
	import flash.display.BitmapData;
	import flash.display.Bitmap;
    	import flash.events.TimerEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.Event;
	import flash.media.Video;
	import flash.media.SoundTransform; 
	import flash.net.NetConnection;
	import flash.net.NetStream;
    	import flash.utils.Timer;
	
	import Box2DAS.Collision.*;
	import Box2DAS.Collision.Shapes.*;
	import Box2DAS.Common.*;
	import Box2DAS.Dynamics.*;
	import Box2DAS.Dynamics.Contacts.*;
	import Box2DAS.Dynamics.Joints.*;

	import stencyl.api.data.*;
	import stencyl.api.engine.*;
	import stencyl.api.engine.actor.*;
	import stencyl.api.engine.behavior.*;
	import stencyl.api.engine.bg.*;
	import stencyl.api.engine.font.*;
	import stencyl.api.engine.scene.*;
	import stencyl.api.engine.sound.*;
	import stencyl.api.engine.tile.*;
	import stencyl.api.engine.utils.*;
	import org.flixel.*;
	
	public dynamic class VideoActor extends ActorScript
	{		
		//Expose your attributes to StencylWorks like this
		[Attribute(id="4", name="VideoURL", desc="Type the URL of the video here. Use either FLV or AVC/H.264/MP4p10. To change at runtime, set 'newVideoURL' on this behavior and tell it to 'changeVideoURL'. This will begin a new video stream without changing the actor. This will only accept a new video of the same width and height.")]
		public var VideoURL:String;
		[Attribute(id="3", name="Loop", desc="Loop the video (otherwise the actor will be deleted when playback ends)")]
		public var LoopOrDelete:Boolean;		
		[Attribute(id="2", name="Video Transparency", desc="[10% - 50% worse performance with 3+ Videos] This video is a VP6 FLV using transparency. This will reduce performance, particularly with multiple videos. It is not nessisary to select this for Stage Video because it handles transparency automatically.")]
		public var VideoTransparency:Boolean;
		[Attribute(id="1", name="Stage Video", desc="[20% - 150% better performance with 3+ Videos] Check this to make a Stage Video instead of a Video Actor. Stage Videos cannot move or interact with the game. They have a performance boost useful for multiple videos. Each actor triggering a Stage Video must be placed on a seperate scene layer, but they will always be displayed above all scene layers.")]
		public var StageVideo:Boolean;

		public var VideoHeight:Number;
		public var VideoWidth:Number;
		public var LoopNumber:Number = 0;
		public var vid:Video = new Video(1, 1);
		public var nc:NetConnection;
		public var ns:NetStream; 
		public var vidBMPData:BitmapData;
		public var vidBMP:Bitmap;
		public var gamePaused:Boolean;
		public var progressTimer:Timer;
		public var videoVolumeTransform:SoundTransform = new SoundTransform();
		public var newVideoURL:String;

		override public function init():void
		{
			loadStream();
		}

		public function loadStream():void
		{
			if (StageVideo){
				actor.disableActorDrawing();
			}
			nc = new NetConnection();
			nc.connect(null);
			ns = new NetStream(nc);
			ns.client = this;
			ns.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			vid.attachNetStream(ns);
			ns.play(VideoURL);		
		}

		public function onMetaData (info:Object):void {
			
			if (LoopNumber == 0){
				print("stream metadata: ");
				for (var prop:String in info) {
					print("\t" + prop + ": " + info[prop]);
					if (prop == "height"){
						VideoHeight = Number(info[prop]);
					}
					else if (prop == "width"){
						VideoWidth = Number(info[prop]);
					}
				}
				print("VideoHeight = " + VideoHeight);
				print("VideoWidth = " + VideoWidth);
				if (!StageVideo){
					vidBMPData = new BitmapData(VideoWidth, VideoHeight, true, 0x000000);
					vidBMP = new Bitmap(vidBMPData, "never");
				}
				LoopNumber = LoopNumber + 1;
				createNewVideo();
			}
		}
		
		private function createNewVideo():void {
				vid = new Video(VideoWidth, VideoHeight);
				vid.attachNetStream(ns);
				ns.play(VideoURL);
				if (StageVideo){
					vid.x = actor.x;
					vid.y = actor.y;
					FlxG.state.addChildAt(vid, actor.layerID);
				}
				else {
					vid.addEventListener(Event.ENTER_FRAME, getImage);
					actor.currSprite.loadExtGraphic(vidBMP, false, false, 0, 0, false, VideoURL);
				}
				progressTimer = new Timer(1000);
				progressTimer.addEventListener(TimerEvent.TIMER, onUpdateProgress);
				progressTimer.start();
		}

		private function onUpdateProgress(event:TimerEvent):void{
			if (FlxG.pause == true && gamePaused == false)
			{
				gamePaused = true;
				if (!StageVideo){
				vid.removeEventListener(Event.ENTER_FRAME, getImage);
				actor.currSprite.loadExtGraphic(vidBMP, false, false, 0, 0, false, VideoURL);
				}
				ns.togglePause();
			}
			if (FlxG.pause == false && gamePaused == true)
			{
				ns.togglePause();
				if (!StageVideo){
				vid.addEventListener(Event.ENTER_FRAME, getImage);
				}
				gamePaused = false;
			}
			if (videoVolumeTransform.volume != FlxG.volume)
			{
				
				videoVolumeTransform.volume = FlxG.volume;
				ns.soundTransform = videoVolumeTransform;
			}
		}

	   private function securityErrorHandler(event:SecurityErrorEvent):void {
            trace("securityErrorHandler: " + event);
        }
	
		public function onNetStatus(evt:NetStatusEvent):void
	   {
			switch (evt.info.code) {
				case "NetStream.Play.Start":
					//print("Case = NetStream.Play.Start");				
					break;
				case "NetStream.Buffer.Flush":
					//print("Case = NetStream.Buffer.Flush = " + vid.name);				
					break;
				case "NetStream.Play.Stop":
					//print("Case = NetStream.Play.Stop");
					if (LoopOrDelete){
						LoopNumber = LoopNumber + 1;
						ns.seek(0);
					}
					else {
						if (!StageVideo){
						vid.removeEventListener(Event.ENTER_FRAME, getImage);
						}
						if (StageVideo){
							FlxG.state.removeChildAt(actor.layerID);
						}
						ns.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
						ns.close;
						nc.close;
						actor.die();
					}
					break;
			}
		}

	    public function getImage(e:Event):void
        {
			if (VideoTransparency){
         		actor.currSprite.fill(0x000000);       			
        		}
        		vidBMPData.draw(vid);
        }

        public function changeVideoURL():void
        {
        		if (newVideoURL != VideoURL){
        			VideoURL = newVideoURL;
        			ns.play(VideoURL);
        		}
        		//print("changeVideoURL to " + VideoURL);
        }
		
		//This is executed every frame of the game
		override public function update():void
		{	
			
		}

		override public function draw(g:Graphics, x:Number, y:Number):void
		{

		}
		
		override public function handleCollision(event:Collision):void
		{
		}
		
		public function VideoActor(actor:Actor, scene:GameState)
		{
			super(actor, scene);

		}
	}
}
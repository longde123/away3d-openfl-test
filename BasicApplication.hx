package ;
import away3d.cameras.Camera3D;
import away3d.containers.Scene3D;
import away3d.containers.View3D;
import away3d.core.managers.Stage3DManager;
import away3d.core.managers.Stage3DProxy;
import away3d.debug.AwayStats;
import away3d.materials.MaterialBase;
import flash.display3D.Context3DCompareMode;
//import away3d.debug.AwayStats;
import away3d.events.Stage3DEvent;
import away3d.textures.BitmapTexture;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.errors.Error;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import away3d.materials.ColorMaterial;
import away3d.primitives.CubeGeometry;
import away3d.textures.BitmapTexture;
import flash.Lib;
import away3d.entities.Mesh;
import away3d.primitives.SphereGeometry;
import away3d.primitives.PlaneGeometry;
import flash.geom.Vector3D;
import away3d.materials.TextureMaterial;
using OpenFLStage3D;
/**
 * ...
 * @author 
 */
class BasicApplication extends Sprite {
 
    private var  _plane: Mesh;
//engine variables
    private var view:View3D;
    private var scene:Scene3D;
    private var camera:Camera3D;
	private var awayStats:AwayStats; 
	
	private var rotY:Float;
    public function new() {
        super(); 
		rotY = 0;
		//new Run();
        this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    }

    private function onAddedToStage(e:Event):Void {
        this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        init();
    }

    private function init():Void { 
		width = 800;
		height = 480;
        initEngine(); 
    }

	
	private function initEngine():Void {
        stage.scaleMode = StageScaleMode.NO_SCALE;  
        stage.align = StageAlign.TOP_LEFT;  
 
		
		view = new View3D();   
	
        //addChild(view);
	 
     
        scene = view.scene;
        camera = view.camera;

       // awayStats = new AwayStats(view);  
       // addChild(awayStats);
		view.camera.z = -600;
        view.camera.y = 500;
        view.camera.lookAt(new Vector3D());
 
        initObjects();
		
        initListeners();
		
		 
	 
	}
	private function initObjects():Void {
//setup the scene
       var logo = openfl.Assets.getBitmapData("assets/hxlogo.png"); 
        var material:TextureMaterial =new TextureMaterial(new BitmapTexture(logo),false);
		  
        _plane = new Mesh(new CubeGeometry(100, 100,100), material);
        view.scene.addChild(_plane);  
		 
    }
 

    private function initListeners():Void {
        addEventListener(Event.ENTER_FRAME, onEnterFrame);
        stage.addEventListener(Event.RESIZE, onResize); 
        onResize();
    }
 
/**
         * Navigation and render loop
         */

    private function onEnterFrame(event:Event):Void {
		//removeEventListener(Event.ENTER_FRAME, onEnterFrame);
        render();
    }
	

    public function   render():Void {
		rotY += 1;
		_plane.rotationY = rotY;
        view.render();
    }

/**
         * stage listener for resize events
         */

    private function onResize(event:Event = null):Void {
        view.x =  0;
		view.y = 0;
		view.width = stage.stageWidth;
		view.height= stage.stageHeight;
        //awayStats.x = stage.stageWidth - awayStats.width;
    }
}
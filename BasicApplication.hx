package ;
import away3d.cameras.Camera3D;
import away3d.containers.Scene3D;
import away3d.containers.View3D;
import away3d.debug.AwayStats;
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
	static function main() {
        var v:Basic_View = new Basic_View();
        Lib.current.addChild(v);
    }
    private var  _plane: Mesh;
//engine variables
    private var view:View3D;
    private var scene:Scene3D;
    private var camera:Camera3D;
    private var awayStats:AwayStats;

    public function new() {
        super();
		//new Run();
        this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    }

    private function onAddedToStage(e:Event):Void {
        this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        init();
    }

    private function init():Void { 
        initEngine();
        initObjects();
        initListeners();
    }
	private function initObjects():Void {
//setup the scene
        var material:ColorMaterial = new ColorMaterial(0xff0000);
        _plane = new Mesh(new CubeGeometry(100, 100,100), material);
        view.scene.addChild(_plane);

 
        var sphere:Mesh = new Mesh(new SphereGeometry(100, 40, 20), material);
        sphere.x = 200;
        sphere.y = 0;
        sphere.z = 0;

        view.scene.addChild(sphere);
		 
    }


/**
         * Initialise the engine
         */

    private function initEngine():Void {
        stage.scaleMode = StageScaleMode.NO_SCALE;
        stage.align = StageAlign.TOP_LEFT;

        view = new View3D();
        addChild(view);
        scene = view.scene;
        camera = view.camera;

        awayStats = new AwayStats(view); 
        addChild(awayStats);
		view.camera.z = -600;
        view.camera.y = 500;
        view.camera.lookAt(new Vector3D());
       
	}
/**
         * Initialise the listeners
         */

    private function initListeners():Void {
        addEventListener(Event.ENTER_FRAME, onEnterFrame);
        stage.addEventListener(Event.RESIZE, onResize); 
        onResize();
    }
 
/**
         * Navigation and render loop
         */

    private function onEnterFrame(event:Event):Void {
        render();
    }

    public function   render():Void {
        view.render();
    }

/**
         * stage listener for resize events
         */

    private function onResize(event:Event = null):Void {
        view.setSizeWH ( stage.stageWidth,stage.stageHeight);
        awayStats.x = stage.stageWidth - awayStats.width;
    }
}
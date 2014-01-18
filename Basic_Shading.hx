/*

Shading example in Away3d

Demonstrates:

How to create multiple lightsources in a scene.
How to apply specular maps, normals maps and diffuse texture maps to a material.

Code by Rob Bateman
rob@infiniteturtles.co.uk
http://www.infiniteturtles.co.uk

This code is distributed under the MIT License

Copyright (c) The Away Foundation http://www.theawayfoundation.org

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the “Software”), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

*/

package;

	import away3d.cameras.*;
	import away3d.containers.*;
	import away3d.controllers.*;
	import away3d.debug.*;
	import away3d.entities.*;
	import away3d.lights.*;
	import away3d.materials.*;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.primitives.*;
	import away3d.textures.BitmapTexture;
	import away3d.utils.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.*;

	import flash.Lib;
import away3d.core.managers.Stage3DManager;
import away3d.core.managers.Stage3DProxy;
@:bitmap("embeds/trinket_diffuse.jpg") class TrinketDiffuse extends BitmapData {}
@:bitmap("embeds/trinket_specular.jpg") class TrinketSpecular extends BitmapData {}
@:bitmap("embeds/trinket_normal.jpg") class TrinketNormals extends BitmapData {}
@:bitmap("embeds/beachball_diffuse.jpg") class BeachBallDiffuse extends BitmapData {}
@:bitmap("embeds/beachball_specular.jpg") class BeachBallSpecular extends BitmapData {}
@:bitmap("embeds/weave_diffuse.jpg") class WeaveDiffuse extends BitmapData {}
@:bitmap("embeds/weave_normal.jpg") class WeaveNormals extends BitmapData {}
@:bitmap("embeds/floor_diffuse.jpg") class FloorDiffuse extends BitmapData {}
@:bitmap("embeds/floor_specular.jpg") class FloorSpecular extends BitmapData {}
@:bitmap("embeds/floor_normal.jpg") class FloorNormals extends BitmapData {}
	
//[SWF(backgroundColor="#000000", frameRate="60", quality="LOW")]
	class Basic_Shading extends Sprite
	{
		//signature swf
    	// [Embed(source="/../embeds/signature.swf", symbol="Signature")]
    	// private var SignatureSwf:Class;
    	
		//cube textures
		// [Embed(source="/../embeds/trinket_diffuse.jpg")]
     	// public static var TrinketDiffuse:Class;
		// [Embed(source="/../embeds/trinket_specular.jpg")]
		// public static var TrinketSpecular:Class;
		// [Embed(source="/../embeds/trinket_normal.jpg")]
		// public static var TrinketNormals:Class;
		
     	//sphere textures
		// [Embed(source="/../embeds/beachball_diffuse.jpg")]
  		//public static var BeachBallDiffuse:Class;
		// [Embed(source="/../embeds/beachball_specular.jpg")]
		// public static var BeachBallSpecular:Class;
		
  		//torus textures
		// [Embed(source="/../embeds/weave_diffuse.jpg")]
		// public static var WeaveDiffuse:Class;
		// [Embed(source="/../embeds/weave_normal.jpg")]
		// public static var WeaveNormals:Class;
		
		//plane textures
		// [Embed(source="/../embeds/floor_diffuse.jpg")]
		// public static var FloorDiffuse:Class;
		// [Embed(source="/../embeds/floor_specular.jpg")]
		// public static var FloorSpecular:Class;
		// [Embed(source="/../embeds/floor_normal.jpg")]
		// public static var FloorNormals:Class;
    	
    	//engine variables
    	private var scene:Scene3D;
		private var camera:Camera3D;
		private var view:View3D;
		private var cameraController:HoverController;
		
		//signature variables
		private var Signature:Sprite;
		private var SignatureBitmap:Bitmap;
		
		//material objects
		private var planeMaterial:TextureMaterial;
		private var sphereMaterial:TextureMaterial;
		private var cubeMaterial:TextureMaterial;
		private var torusMaterial:TextureMaterial;

		//light objects
		private var light1:DirectionalLight;
		private var light2:DirectionalLight;
		private var lightPicker:StaticLightPicker;
		
		//scene objects
		private var plane:Mesh;
		private var sphere:Mesh;
		private var cube:Mesh;
		private var torus:Mesh;
		
		//navigation variables
		private var move:Bool = false;
		private var lastPanAngle:Float;
		private var lastTiltAngle:Float;
		private var lastMouseX:Float;
		private var lastMouseY:Float;
		private var _stage3DManager:Stage3DManager; 
		private var _stage3DProxy:Stage3DProxy;
		/**
		 * Constructor
		 */
		public function new()
		{
			super();
			  
			init();
		}
		
		/**
		 * Global initialise function
		 */
		private function init():Void
		{
			initEngine();
			initLights();
			initMaterials();
			initObjects();
			initListeners();
		}
		
		/**
		 * Initialise the engine
		 */
		private function initEngine():Void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			scene = new Scene3D();
			
			camera = new Camera3D();

			_stage3DManager = Stage3DManager.getInstance(stage); 
			_stage3DProxy = _stage3DManager.getFreeStage3DProxy();
 
		
			view = new View3D();  
			view.stage3DProxy = _stage3DProxy;
			view.antiAlias = 4;
			view.scene = scene;
			view.camera = camera;
			
			//setup controller to be used on the camera
			cameraController = new HoverController(camera);
			cameraController.distance = 1000;
			cameraController.minTiltAngle = 0;
			cameraController.maxTiltAngle = 90;
			cameraController.panAngle = 45;
			cameraController.tiltAngle = 20;
			
			//view.addSourceURL("srcview/index.html");
			//addChild(view);
			
			//add signature
			// Signature = Sprite(new SignatureSwf());
			// SignatureBitmap = new Bitmap(new BitmapData(Signature.width, Signature.height, true, 0));
			// stage.quality = StageQuality.HIGH;
			// SignatureBitmap.bitmapData.draw(Signature);
			// stage.quality = StageQuality.LOW;
			// addChild(SignatureBitmap);
		
			//addChild(new AwayStats(view));

			var fps = new openfl.display.FPS(0, 0, 0xffffff);
			fps.scaleX = fps.scaleY = 4;
			this.addChild(fps);
		}
		
		/**
		 * Initialise the materials
		 */
		private function initMaterials():Void
		{
			planeMaterial = new TextureMaterial(Cast.bitmapTexture(FloorDiffuse));
			planeMaterial.specularMap = Cast.bitmapTexture(FloorSpecular);
			planeMaterial.normalMap = Cast.bitmapTexture(FloorNormals);
			planeMaterial.lightPicker = lightPicker;
			planeMaterial.repeat = true;
			planeMaterial.mipmap = false;
			
			sphereMaterial = new TextureMaterial(Cast.bitmapTexture(BeachBallDiffuse));
			sphereMaterial.specularMap = Cast.bitmapTexture(BeachBallSpecular);
			sphereMaterial.lightPicker = lightPicker;
			
			cubeMaterial = new TextureMaterial(Cast.bitmapTexture(TrinketDiffuse));
			cubeMaterial.specularMap = Cast.bitmapTexture(TrinketSpecular);
			cubeMaterial.normalMap = Cast.bitmapTexture(TrinketNormals);
			cubeMaterial.lightPicker = lightPicker;
			cubeMaterial.mipmap = false;
			
			var weaveDiffuseTexture:BitmapTexture = Cast.bitmapTexture(WeaveDiffuse);
			torusMaterial = new TextureMaterial(weaveDiffuseTexture);
			torusMaterial.specularMap = weaveDiffuseTexture;
			torusMaterial.normalMap = Cast.bitmapTexture(WeaveNormals);
			torusMaterial.lightPicker = lightPicker;
			torusMaterial.repeat = true;
		}
		
		/**
		 * Initialise the lights
		 */
		private function initLights():Void
		{
			light1 = new DirectionalLight();
			light1.direction = new Vector3D(0, -1, 0);
			light1.ambient = 0.1;
			light1.diffuse = 0.7;
			
			scene.addChild(light1);
			
			light2 = new DirectionalLight();
			light2.direction = new Vector3D(0, -1, 0);
			light2.color = 0x00FFFF;
			light2.ambient = 0.1;
			light2.diffuse = 0.7;
			
			scene.addChild(light2);
			
			lightPicker = new StaticLightPicker([light1, light2]);
		}
		
		/**
		 * Initialise the scene objects
		 */
		private function initObjects():Void
		{
			plane = new Mesh(new PlaneGeometry(1000, 1000), planeMaterial);
			plane.geometry.scaleUV(2, 2);
			plane.y = -20;
			
			scene.addChild(plane);
			
	        sphere = new Mesh(new SphereGeometry(150, 40, 20), sphereMaterial);
	        sphere.x = 300;
	        sphere.y = 160;
	        sphere.z = 300;
	        
			scene.addChild(sphere);
			
	        cube = new Mesh(new CubeGeometry(200, 200, 200, 1, 1, 1, false), cubeMaterial);
	        cube.x = 300;
	        cube.y = 160;
	        cube.z = -250;
	        
			scene.addChild(cube);
			
	        torus = new Mesh(new TorusGeometry(150, 60, 40, 20), torusMaterial);
			torus.geometry.scaleUV(10, 5);
	        torus.x = -250;
	        torus.y = 160;
	        torus.z = -250;
			
			scene.addChild(torus);
		}
		
		/**
		 * Initialise the listeners
		 */
		private function initListeners():Void
		{
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			//view.stage3DProxy.context3D.setRenderMethod(onEnterFrame);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			stage.addEventListener(Event.RESIZE, onResize);
			onResize();
		}
		
		/**
		 * Navigation and render loop
		 */
		private function onEnterFrame(event:Event):Void
		{
			if (move) {
			 	cameraController.panAngle = 0.3*(stage.mouseX - lastMouseX) + lastPanAngle;
			 	cameraController.tiltAngle = 0.3*(stage.mouseY - lastMouseY) + lastTiltAngle;
			}
			
			light1.direction = new Vector3D(Math.sin(Lib.getTimer()/10000)*150000, 1000, Math.cos(Lib.getTimer()/10000)*150000);
			
			view.render();
		}
		
		/**
		 * Mouse down listener for navigation
		 */
		private function onMouseDown(event:MouseEvent):Void
		{
			lastPanAngle = cameraController.panAngle;
			lastTiltAngle = cameraController.tiltAngle;
			lastMouseX = stage.mouseX;
			lastMouseY = stage.mouseY;
			move = true;
			stage.addEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
		}
		
		/**
		 * Mouse up listener for navigation
		 */
		private function onMouseUp(event:MouseEvent):Void
		{
			move = false;
			stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
		}
		
		/**
		 * Mouse stage leave listener for navigation
		 */
		private function onStageMouseLeave(event:Event):Void
		{
			move = false;
			stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
		}
		
		/**
		 * stage listener for resize events
		 */
		private function onResize(event:Event = null):Void
		{
			view.width = stage.stageWidth;
			view.height = stage.stageHeight;
			//SignatureBitmap.y = stage.stageHeight - Signature.height;
		}
	}
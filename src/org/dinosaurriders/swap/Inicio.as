package org.dinosaurriders.swap {
	import org.flixel.FlxButton;
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	/**
	 * @author ieiomeli
	 */
	
	
	public class Inicio extends FlxState{
		private var texto:FlxText;
		
		public function Inicio()
        {
            super();
        }
		
		override public function create():void
        {
            var s:FlxSprite = new FlxSprite();
			s.makeGraphic(FlxG.width, FlxG.height, 0x000000);
            add(s);
			
 			texto=new FlxText(0, 300, FlxG.width, "Al infinito").setFormat(null, 21, 0xFF0000, "center");
         
          	add(texto);
		   	var botonInicio:FlxButton =  new FlxButton(FlxG.width / 2 - 40, FlxG.height / 2 - 60, "Start Game!", iniciar);
			add(botonInicio);
			
			FlxG.flash(0xffffff, 1);
			FlxG.shake(0.005, 3);
		}

		private function iniciar() : void {
			FlxG.switchState(new LevelContainer("Level1"));
		}

		override public function update():void
	    {
	        super.update();
			texto.x++;
	    }
	}
}

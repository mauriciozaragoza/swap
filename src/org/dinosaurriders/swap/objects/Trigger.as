package org.dinosaurriders.swap.objects {
	import org.flixel.FlxSprite;
	/**
	 * @author Mau
	 */
	public class Trigger extends FlxSprite
	{
		public var target:String = "";
		public var targetObject:Object = null;
		public var itKills = false;
		
		public function Trigger( X:Number, Y:Number, Width:uint, Height:uint ) 
		{
			super(X, Y);
			width = Width;
			height = Height;
			visible = false;
		}
		
		public function ParseProperties( properties:Array):void
		{
			if ( properties )
			{
				var i:int = properties.length;
				while(i--)
				{
					if ( properties[i].name == "target" )
					{
						target = properties[i].value;
					}
					else if (properties[i].name == "kill")
					{
						itKills = properties[i].value;
						trace("found kill", properties[i].value, itKills);
					}
				}
			}
		}
		
		public function AddLinkTo(obj:Object):void
		{
			targetObject = obj;
		}
	}
}


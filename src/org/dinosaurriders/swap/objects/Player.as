package org.dinosaurriders.swap.objects {
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Common.Math.b2Vec2;

	import org.dinosaurriders.swap.Assets;
	import org.dinosaurriders.swap.Settings;
	import org.flixel.*;
	
	public class Player extends PhysicalBody
	{		
		public function Player(X:Number,Y:Number):void {
			super(X, Y, 0.3, 0, 1);
			loadGraphic(Assets.Player, true, true, 48, 48);
			
			addAnimation("jump", [1], 10);
			addAnimation("move", [0, 1, 2], 10);
			addAnimation("fall", [1], 10);
			addAnimation("idle", [1], 2);			

//			addAnimation("jump", [3], 10);
//			addAnimation("move", [1, 2], 10);
//			addAnimation("fall", [3], 10);
//			addAnimation("idle", [0], 2);

//			var polyDef : b2PolygonShape = new b2PolygonShape();
//			polyDef.SetAsBox(width / Settings.ratio / 2, height / Settings.ratio / 2);
//			fixtureDef.shape = polyDef;
			var circleDef : b2CircleShape = new b2CircleShape();
			circleDef.SetRadius(width / Settings.ratio / 2);
			fixtureDef.shape = circleDef;
			bodyDef.fixedRotation = true;
		}
		
		override public function update():void 
		{
			var velocity : b2Vec2 = body.GetLinearVelocity();
			
			if (FlxG.keys.LEFT && velocity.x > -Settings.PLAYERMAXVELOCITY)
			{
				angle = 180; 
				body.ApplyImpulse(new b2Vec2(-Settings.PLAYERSPEED), new b2Vec2());
			}
			else if (FlxG.keys.RIGHT && velocity.x < Settings.PLAYERMAXVELOCITY)
			{
				angle = 0;
				body.ApplyImpulse(new b2Vec2(Settings.PLAYERSPEED), new b2Vec2());
			}			
			else if (FlxG.keys.justPressed("UP")) {
				body.ApplyImpulse(new b2Vec2(0, -Settings.PLAYERJUMP), new b2Vec2());
			}
			
			// disable friction while jumping
			fixtureDef.friction = 0;
			
			
//			if(!grounded) {			
//				playerPhysicsFixture.setFriction(0f);
//				playerSensorFixture.setFriction(0f);			
//			} else {
//				if(!Gdx.input.isKeyPressed(Keys.A) && !Gdx.input.isKeyPressed(Keys.D) && stillTime > 0.2) {
//					playerPhysicsFixture.setFriction(100f);
//					playerSensorFixture.setFriction(100f);
//				}
//				else {
//					playerPhysicsFixture.setFriction(0.2f);
//					playerSensorFixture.setFriction(0.2f);
//				}
//	 
//				if(groundedPlatform != null && groundedPlatform.dist == 0) {
//					player.applyLinearImpulse(0, -24, pos.x, pos.y);				
//				}
//			}		
			
			if (velocity.y < 0)
			{
				play("jump");
			}
			else
			{
				if (velocity.y > 0)
				{
					play("fall");
				}
				else if (velocity.x == 0)
				{
					play("idle");
				}
				else
				{
					play("move");
				}
			}
			
			super.update();
		}
		
//		private boolean isPlayerGrounded(float deltaTime) {				
//			groundedPlatform = null;
//			List<Contact> contactList = world.getContactList();
//			for(int i = 0; i < contactList.size(); i++) {
//				Contact contact = contactList.get(i);
//				if(contact.isTouching() && (contact.getFixtureA() == playerSensorFixture ||
//				   contact.getFixtureB() == playerSensorFixture)) {				
//	 
//					Vector2 pos = player.getPosition();
//					WorldManifold manifold = contact.getWorldManifold();
//					boolean below = true;
//					for(int j = 0; j < manifold.getNumberOfContactPoints(); j++) {
//						below &= (manifold.getPoints()[j].y < pos.y - 1.5f);
//					}
//	 
//					if(below) {
//						if(contact.getFixtureA().getUserData() != null && contact.getFixtureA().getUserData().equals("p")) {
//							groundedPlatform = (MovingPlatform)contact.getFixtureA().getBody().getUserData();							
//						}
//	 
//						if(contact.getFixtureB().getUserData() != null && contact.getFixtureB().getUserData().equals("p")) {
//							groundedPlatform = (MovingPlatform)contact.getFixtureB().getBody().getUserData();
//						}											
//						return true;			
//					}
//	 
//					return false;
//				}
//			}
//			return false;
//		}

	}
}
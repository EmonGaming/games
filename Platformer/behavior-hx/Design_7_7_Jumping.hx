package scripts;

import com.stencyl.graphics.G;
import com.stencyl.graphics.BitmapWrapper;

import com.stencyl.behavior.Script;
import com.stencyl.behavior.Script.*;
import com.stencyl.behavior.ActorScript;
import com.stencyl.behavior.SceneScript;
import com.stencyl.behavior.TimedTask;

import com.stencyl.models.Actor;
import com.stencyl.models.GameModel;
import com.stencyl.models.actor.Animation;
import com.stencyl.models.actor.ActorType;
import com.stencyl.models.actor.Collision;
import com.stencyl.models.actor.Group;
import com.stencyl.models.Scene;
import com.stencyl.models.Sound;
import com.stencyl.models.Region;
import com.stencyl.models.Font;

import com.stencyl.Engine;
import com.stencyl.Input;
import com.stencyl.Key;
import com.stencyl.utils.Utils;

import openfl.ui.Mouse;
import openfl.display.Graphics;
import openfl.display.BlendMode;
import openfl.display.BitmapData;
import openfl.display.Bitmap;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.events.TouchEvent;
import openfl.net.URLLoader;

import box2D.common.math.B2Vec2;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2Fixture;
import box2D.dynamics.joints.B2Joint;

import motion.Actuate;
import motion.easing.Back;
import motion.easing.Cubic;
import motion.easing.Elastic;
import motion.easing.Expo;
import motion.easing.Linear;
import motion.easing.Quad;
import motion.easing.Quart;
import motion.easing.Quint;
import motion.easing.Sine;

import com.stencyl.graphics.shaders.BasicShader;
import com.stencyl.graphics.shaders.GrayscaleShader;
import com.stencyl.graphics.shaders.SepiaShader;
import com.stencyl.graphics.shaders.InvertShader;
import com.stencyl.graphics.shaders.GrainShader;
import com.stencyl.graphics.shaders.ExternalShader;
import com.stencyl.graphics.shaders.InlineShader;
import com.stencyl.graphics.shaders.BlurShader;
import com.stencyl.graphics.shaders.SharpenShader;
import com.stencyl.graphics.shaders.ScanlineShader;
import com.stencyl.graphics.shaders.CSBShader;
import com.stencyl.graphics.shaders.HueShader;
import com.stencyl.graphics.shaders.TintShader;
import com.stencyl.graphics.shaders.BloomShader;



class Design_7_7_Jumping extends ActorScript
{          	
	
public var _KeyReleased:Bool;

public var _CanJump:Bool;

public var _JumpKey:String;

public var _MaxJumpTime:Float;

public var _JumpRightAnimation:String;

public var _JumpLeftAnimation:String;

public var _PreventJumping:Bool;

public var _ElapsedJumpTime:Float;

public var _oldY:Float;

public var _CurrentJumpTime:Float;

public var _JumpSound:Sound;

public var _JumpingSlowdown:Float;

public var _AnimationCategory:String;

public var _JumpForce:Float;

 
 	public function new(dummy:Int, actor:Actor, dummy2:Engine)
	{
		super(actor);
		nameMap.set("Key Released?", "_KeyReleased");
_KeyReleased = false;
nameMap.set("Can Jump?", "_CanJump");
_CanJump = false;
nameMap.set("Jump Key", "_JumpKey");
nameMap.set("Max Jump Time", "_MaxJumpTime");
_MaxJumpTime = 0.075;
nameMap.set("Jump Right Animation", "_JumpRightAnimation");
nameMap.set("Jump Left Animation", "_JumpLeftAnimation");
nameMap.set("Prevent Jumping?", "_PreventJumping");
_PreventJumping = false;
nameMap.set("Elapsed Jump Time", "_ElapsedJumpTime");
_ElapsedJumpTime = 0.0;
nameMap.set("Actor", "actor");
nameMap.set("oldY", "_oldY");
_oldY = 0.0;
nameMap.set("Current Jump Time", "_CurrentJumpTime");
_CurrentJumpTime = 0.0;
nameMap.set("Jump Sound", "_JumpSound");
nameMap.set("Jumping Slowdown", "_JumpingSlowdown");
_JumpingSlowdown = 0.75;
nameMap.set("Animation Category", "_AnimationCategory");
_AnimationCategory = "Jumping";
nameMap.set("Jump Force", "_JumpForce");
_JumpForce = 35.0;

	}
	
	override public function init()
	{
		    
/* ======================== When Creating ========================= */
        /* "Inputs: ----------------------" */
        /* "\"On Ground?\" -- <Boolean> Actor Level Attribute, from \"On Ground\" Behavior (required)" */
        /* "\"Facing Right?\" -- <Boolean> Actor Level Attribute, from \"Walking\" Behavior (required)" */
        /* "Outputs: ---------------------" */
        /* "\"Is Jumping?\" -- <Boolean> Actor Level Attribute" */
    
/* ======================== When Updating ========================= */
addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void
{
if(wrapper.enabled)
{
        /* "If we're on the ground, we're not jumping" */
        if(asBoolean(actor.getActorValue("On Ground?")))
{
            actor.setActorValue("Is Jumping?", false);
            actor.say("Animation Manager", "_customBlock_ClearAnimCat", [_AnimationCategory]);
            if(_KeyReleased)
{
                _CanJump = true;
propertyChanged("_CanJump", _CanJump);
}

}

        /* "Check for the jump key press, but also allow a bit of leeway for smoother jumping" */
        if(isKeyPressed(_JumpKey))
{
            if(!(asBoolean(actor.getActorValue("On Ground?"))))
{
                runLater(1000 * 0.15, function(timeTask:TimedTask):Void {
                            if(actor.isAlive())
{
                                if(!(asBoolean(actor.getActorValue("On Ground?"))))
{
                                    _KeyReleased = false;
propertyChanged("_KeyReleased", _KeyReleased);
}

}

}, actor);
}

}

        /* "Detect the release of the jump key" */
        if((!(_KeyReleased) && !(isKeyDown(_JumpKey))))
{
            _KeyReleased = true;
propertyChanged("_KeyReleased", _KeyReleased);
            /* "If we're still in the middle of jumping, slow down our upward ascent" */
            if((asBoolean(actor.getActorValue("Is Jumping?")) && (actor.getY() < _oldY)))
{
                actor.setYVelocity((actor.getYVelocity() * _JumpingSlowdown));
}

}

        /* "Detect the jump key press, and initiate the jump" */
        if((isKeyDown(_JumpKey) && (_CanJump && (_KeyReleased && asBoolean(actor.getActorValue("On Ground?"))))))
{
            playSound(_JumpSound);
            _ElapsedJumpTime = asNumber(0);
propertyChanged("_ElapsedJumpTime", _ElapsedJumpTime);
            actor.setYVelocity(-(_JumpForce));
            _CanJump = false;
propertyChanged("_CanJump", _CanJump);
            _KeyReleased = false;
propertyChanged("_KeyReleased", _KeyReleased);
            /* "Add a small delay before setting the jumping flag, since another collision can occur before the Actor" */
            /* "gets off the ground, and this would just reset the flag to FALSE." */
            runLater(1000 * 0.075, function(timeTask:TimedTask):Void {
                        if(actor.isAlive())
{
                            actor.setActorValue("Is Jumping?", true);
}

}, actor);
            return;
}

        /* "If we are currently jumping, set the jumping animation" */
        if(asBoolean(actor.getActorValue("Is Jumping?")))
{
            _ElapsedJumpTime += 1;
propertyChanged("_ElapsedJumpTime", _ElapsedJumpTime);
            if(asBoolean(actor.getActorValue("Facing Right?")))
{
                if((actor.getY() < _oldY))
{
                    actor.say("Animation Manager", "_customBlock_LoopAnim", [_JumpRightAnimation,_AnimationCategory]);
}

}

            else
{
                if((actor.getY() < _oldY))
{
                    actor.say("Animation Manager", "_customBlock_LoopAnim", [_JumpLeftAnimation,_AnimationCategory]);
}

}

            /* "Check to see if the amount of time we've been jumping for has exceeded the max jumping time" */
            /* "if not, keep setting the jump velocity" */
            if((_ElapsedJumpTime <= ((_MaxJumpTime * 1000) / getStepSize())))
{
                if((isKeyDown(_JumpKey) && (!(_KeyReleased) && (actor.getY() < _oldY))))
{
                    actor.setYVelocity(-(_JumpForce));
}

}

}

        _oldY = asNumber(actor.getY());
propertyChanged("_oldY", _oldY);
}
});

	}	      	
	
	override public function forwardMessage(msg:String)
	{
		
	}
}
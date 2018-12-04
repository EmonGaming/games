#import <Box2D/Box2D.h>
#import <AudioToolbox/AudioServices.h>
#import <Foundation/Foundation.h>
#import "ActorScript.h"

#import "Script.h"

#import "Actor.h"
#import "ActorType.h"
#import "Assets.h"
#import "Behavior.h"
#import "Collision.h"
#import "CollisionPoint.h"
#import "Game.h"
#import "GameModel.h"
#import "GroupDef.h"
#import "FadeInTransition.h"
#import "FadeOutTransition.h"
#import "Region.h"
#import "Runnable.h"
#import "Scene.h"
#import "SHThumbstick.h"
#import "Sparrow.h"
#import "Transition.h"



@interface Design_35_35_PlatformMotion : ActorScript 
{
	@public
		NSString* tempHolder;
		
float _Direction;

BOOL _ReverseStartingDirection;

float _Period;

float _Speed;

BOOL _ApplySmoothing;

float _ElapsedTime;

float _CurrentDirection;

float _SlowdownSpeed;

float _ReverseDirection;

float _CurrentSpeed;

}
@end

@implementation Design_35_35_PlatformMotion

    -(void)load
{
        [mActor makeAlwaysSimulate];
        _Period = (_Period * 1000);
        if(!(_ReverseStartingDirection))
{
            _Speed = -(_Speed);
}

        _CurrentSpeed = _Speed;
        if([self sameAs:[NSNumber numberWithFloat:_Direction] two:[NSNumber numberWithFloat:0]])
{
            [mActor setYVelocity:_Speed];
}

        else if([self sameAs:[NSNumber numberWithFloat:_Direction] two:[NSNumber numberWithFloat:1]])
{
            [mActor setXVelocity:_Speed];
}

        else if([self sameAs:[NSNumber numberWithFloat:_Direction] two:[NSNumber numberWithFloat:2]])
{
            [mActor setXVelocity:_Speed];
            [mActor setYVelocity:_Speed];
}

        else
{
            [mActor setXVelocity:-(_Speed)];
            [mActor setYVelocity:_Speed];
}

}

    -(void)update
{
        _ElapsedTime += 1;
        if((_ElapsedTime >= (_Period / (1000 * STEP_SIZE))))
{
            _ElapsedTime = 0;
            _Speed = -(_Speed);
            _CurrentSpeed = _Speed;
            if([self sameAs:[NSNumber numberWithFloat:_Direction] two:[NSNumber numberWithFloat:0]])
{
                [mActor setYVelocity:_Speed];
}

            else if([self sameAs:[NSNumber numberWithFloat:_Direction] two:[NSNumber numberWithFloat:1]])
{
                [mActor setXVelocity:_Speed];
}

            else if([self sameAs:[NSNumber numberWithFloat:_Direction] two:[NSNumber numberWithFloat:2]])
{
                [mActor setXVelocity:_Speed];
                [mActor setYVelocity:_Speed];
}

            else
{
                [mActor setXVelocity:-(_Speed)];
                [mActor setYVelocity:_Speed];
}

}

        else
{
            if(_ApplySmoothing)
{
                if((_ElapsedTime >= ((_Period / (1000 * STEP_SIZE)) - 100)))
{
                    _SlowdownSpeed = fabs(((_ElapsedTime - (_Period / (1000 * STEP_SIZE))) / 100));
                    _CurrentSpeed = (_Speed * _SlowdownSpeed);
}

                else
{
                    if((_ElapsedTime < 100))
{
                        _SlowdownSpeed = (_ElapsedTime / 100);
                        _CurrentSpeed = (_Speed * _SlowdownSpeed);
}

}

                if([self sameAs:[NSNumber numberWithFloat:_Direction] two:[NSNumber numberWithFloat:0]])
{
                    [mActor setYVelocity:_CurrentSpeed];
}

                else if([self sameAs:[NSNumber numberWithFloat:_Direction] two:[NSNumber numberWithFloat:1]])
{
                    [mActor setXVelocity:_CurrentSpeed];
}

                else if([self sameAs:[NSNumber numberWithFloat:_Direction] two:[NSNumber numberWithFloat:2]])
{
                    [mActor setXVelocity:_CurrentSpeed];
                    [mActor setYVelocity:_CurrentSpeed];
}

                else
{
                    [mActor setXVelocity:-(_CurrentSpeed)];
                    [mActor setYVelocity:_CurrentSpeed];
}

}

}

}

    -(void)handleCollision:(Collision*)c
{

}

    -(void)render:(SPRenderSupport*)g x:(int)x y:(int)y
{
[super render:g x:x y:y];

}



-(void)forwardMessage:(NSString*)msg
{
	
}

@end
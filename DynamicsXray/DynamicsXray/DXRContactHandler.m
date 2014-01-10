//
//  DXRContactHandler.m
//  DynamicsXray
//
//  Created by Chris Miles on 10/01/2014.
//  Copyright (c) 2014 Chris Miles. All rights reserved.
//

#import "DXRContactHandler.h"
@import UIKit;

@import ObjectiveC.runtime;

#import "NSObject+CMObjectIntrospection.h"


typedef NS_ENUM(NSInteger, DXRPhysicsBodyShapeType)
{
    DXRPhysicsBodyShapeTypeUnknown0 = 0,
    DXRPhysicsBodyShapeTypeUnknown1,
    DXRPhysicsBodyShapeTypeRectangle,
    DXRPhysicsBodyShapeTypeUnknown3,
    DXRPhysicsBodyShapeTypeUnknown4,
    DXRPhysicsBodyShapeTypeUnknown5,
    DXRPhysicsBodyShapeTypeEdgeLoop,
};


NSString * const DXRDynamicsXrayContactDidBeginNotification = @"DXRDynamicsXrayContactDidBeginNotification";
NSString * const DXRDynamicsXrayContactDidEndNotification = @"DXRDynamicsXrayContactDidEndNotification";


@implementation DXRContactHandler


#pragma mark - Handle Contact with PKPhysicsContact

+ (void)handleBeginContactWithPhysicsContact:(PKPhysicsContact *)physicsContact
{

    PKPhysicsBody *bodyA = physicsContact.bodyA;
    PKPhysicsBody *bodyB = physicsContact.bodyB;

    //NSInteger dynamicTypeA = [[bodyA valueForKey:@"_dynamicType"] integerValue];
    //NSInteger dynamicTypeB = [[bodyB valueForKey:@"_dynamicType"] integerValue];

    NSInteger shapeTypeA = [[bodyA valueForKey:@"_shapeType"] integerValue];
    NSInteger shapeTypeB = [[bodyB valueForKey:@"_shapeType"] integerValue];

    if (shapeTypeA == DXRPhysicsBodyShapeTypeEdgeLoop) {
        Class bodyClass = NSClassFromString(@"PKPhysicsBody");

        CGPathRef path = CFBridgingRetain([bodyA getValueForIvarWithName:@"_path" class:bodyClass]);
        if (path) {
            [self handleBeginContactWithShapePath:path];
        }
    }
    if (shapeTypeB == DXRPhysicsBodyShapeTypeEdgeLoop) {
        Class bodyClass = NSClassFromString(@"PKPhysicsBody");
        CGPathRef path = CFBridgingRetain([bodyB getValueForIvarWithName:@"_path" class:bodyClass]);
        if (path) {
            [self handleBeginContactWithShapePath:path];
        }
    }

    id objectA = bodyA.representedObject;
    id objectB = bodyB.representedObject;

    //DLog(@"physicsContact: %@", physicsContact);
    //DLog(@"bodyA: %@ objectA: %@ dynamicType=%ld shapeType=%ld", bodyA, objectA, (long)dynamicTypeA, (long)shapeTypeA);
    //DLog(@"bodyB: %@ objectB: %@ dynamicType=%ld shapeType=%ld", bodyB, objectB, (long)dynamicTypeB, (long)shapeTypeB);

    if (objectA) [self handleBeginContactWithObject:objectA];
    if (objectB) [self handleBeginContactWithObject:objectB];
}

+ (void)handleEndContactWithPhysicsContact:(PKPhysicsContact *)physicsContact
{
    PKPhysicsBody *bodyA = physicsContact.bodyA;
    PKPhysicsBody *bodyB = physicsContact.bodyB;

    NSInteger shapeTypeA = [[bodyA valueForKey:@"_shapeType"] integerValue];
    NSInteger shapeTypeB = [[bodyB valueForKey:@"_shapeType"] integerValue];

    if (shapeTypeA == DXRPhysicsBodyShapeTypeEdgeLoop) {
        Class bodyClass = NSClassFromString(@"PKPhysicsBody");
        CGPathRef path = CFBridgingRetain([bodyA getValueForIvarWithName:@"_path" class:bodyClass]);
        if (path) {
            [self handleEndContactWithShapePath:path];
        }
    }
    if (shapeTypeB == DXRPhysicsBodyShapeTypeEdgeLoop) {
        Class bodyClass = NSClassFromString(@"PKPhysicsBody");
        CGPathRef path = CFBridgingRetain([bodyB getValueForIvarWithName:@"_path" class:bodyClass]);
        if (path) {
            [self handleEndContactWithShapePath:path];
        }
    }

    id objectA = bodyA.representedObject;
    id objectB = bodyB.representedObject;

    //DLog(@"physicsContact: %@", physicsContact);
    //DLog(@"bodyA: %@ objectA: %@", bodyA, objectA);
    //DLog(@"bodyB: %@ objectB: %@", bodyB, objectB);

    [self handleEndContactWithObject:objectA];
    [self handleEndContactWithObject:objectB];
}


#pragma mark - Handle Contact with Objects

+ (void)handleBeginContactWithObject:(id)object
{
    if (object && [object conformsToProtocol:@protocol(UIDynamicItem)]) {
        //DLog(@"DynamicItem began contact %@", object);

        NSDictionary *userInfo = @{@"dynamicItem": object};
        [[NSNotificationCenter defaultCenter] postNotificationName:DXRDynamicsXrayContactDidBeginNotification object:self userInfo:userInfo];
    }
    else {
        DLog(@"Unhandled contact object: %@", object);
    }
}

+ (void)handleEndContactWithObject:(id)object
{
    if (object && [object conformsToProtocol:@protocol(UIDynamicItem)]) {
        //DLog(@"DynamicItem end contact %@", object);

        NSDictionary *userInfo = @{@"dynamicItem": object};
        [[NSNotificationCenter defaultCenter] postNotificationName:DXRDynamicsXrayContactDidEndNotification object:self userInfo:userInfo];
    }
    else {
        DLog(@"Unhandled contact object: %@", object);
    }
}


#pragma mark - Handle Contact with Shape Path

+ (void)handleBeginContactWithShapePath:(CGPathRef)path
{
    if (path) {
        id obj = (__bridge id)(path);
        NSDictionary *userInfo = @{@"path": obj};
        [[NSNotificationCenter defaultCenter] postNotificationName:DXRDynamicsXrayContactDidBeginNotification object:self userInfo:userInfo];
    }
}

+ (void)handleEndContactWithShapePath:(CGPathRef)path
{
    if (path) {
        id obj = (__bridge id)(path);
        NSDictionary *userInfo = @{@"path": obj};
        [[NSNotificationCenter defaultCenter] postNotificationName:DXRDynamicsXrayContactDidEndNotification object:self userInfo:userInfo];
    }
}

@end

//
//  DXRDynamicsXrayConfigurationViewController_Internal.h
//  DynamicsXray
//
//  Created by Chris Miles on 24/10/13.
//  Copyright (c) 2013 Chris Miles. All rights reserved.
//

#import "DXRDynamicsXrayConfigurationViewController.h"
#import "DXRDynamicsXrayConfigurationControlsView.h"
#import "DynamicsXray.h"

@interface DXRDynamicsXrayConfigurationViewController ()

@property (weak, nonatomic) DynamicsXray *dynamicsXray;

@property (assign, nonatomic) BOOL animateAppearance;

@property (assign, nonatomic) BOOL initialAppearanceWasAnimated;
@property (strong, nonatomic) DXRDynamicsXrayConfigurationControlsView *controlsView;

- (void)transitionOutAnimatedWithCompletion:(void (^)(void))completion;

@end

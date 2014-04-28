//
//  DXRDynamicXrayConfigurationControlsView.m
//  DynamicsXray
//
//  Created by Chris Miles on 6/03/2014.
//  Copyright (c) 2014 Chris Miles. All rights reserved.
//

#import "DXRDynamicXrayConfigurationControlsView.h"

#import "DXRDynamicXrayConfigurationActiveView.h"
#import "DXRDynamicXrayConfigurationTitleView.h"
#import "DXRDynamicXrayConfigurationFaderView.h"


@interface DXRDynamicXrayConfigurationControlsView ()

@property (strong, nonatomic) UIView *contentsView;

@property (strong, nonatomic) DXRDynamicXrayConfigurationActiveView *activeView;
@property (strong, nonatomic) DXRDynamicXrayConfigurationFaderView *faderView;
@property (strong, nonatomic) DXRDynamicXrayConfigurationTitleView *titleView;
@property (strong, nonatomic) UIView *titleFaderSeparatorView;

@end


@implementation DXRDynamicXrayConfigurationControlsView

- (id)initWithLayoutStyle:(DXRDynamicsXrayConfigurationControlsLayoutStyle)layoutStyle
{
    self = [super initWithFrame:CGRectZero];
    if (self)
    {
        // Add a UIToolbar simply to get its nice blur :)

        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:self.bounds];
        toolbar.barStyle = UIBarStyleBlackTranslucent;
        toolbar.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        [self addSubview:toolbar];

        // Contents container for controls, labels, etc

        UIView *contentsView = [[UIView alloc] initWithFrame:self.bounds];
        contentsView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        contentsView.backgroundColor = [UIColor clearColor];
        [self addSubview:contentsView];

        // Titles and Controls

        self.titleView = [self newTitleView];
        self.activeView = [self newActiveView];
        self.faderView = [self newFaderView];

        [contentsView addSubview:self.titleView];
        [contentsView addSubview:self.faderView];
        [contentsView addSubview:self.activeView];

        if (layoutStyle == DXRDynamicsXrayConfigurationControlsLayoutStyleNarrow) {
            self.titleFaderSeparatorView = [self newTitleFaderSeparatorView];
            [contentsView addSubview:self.titleFaderSeparatorView];
        }

        self.contentsView = contentsView;

        if (layoutStyle == DXRDynamicsXrayConfigurationControlsLayoutStyleNarrow) {
            [self configureLayoutForNarrowLayoutStyle];
        }
        else {
            [self configureLayoutForWideLayoutStyle];
        }
    }
    return self;
}

- (void)configureLayoutForNarrowLayoutStyle
{
    UIView *activeView = self.activeView;
    UIView *contentsView = self.contentsView;
    UIView *faderView = self.faderView;
    UIView *titleFaderSeparatorView = self.titleFaderSeparatorView;
    UIView *titleView = self.titleView;

    NSDictionary *layoutViews = NSDictionaryOfVariableBindings(activeView, faderView, titleFaderSeparatorView, titleView);

    UIScreen *screen = (self.window.screen ?: [UIScreen mainScreen]);
    CGFloat scale = screen.scale;
    CGSize titleViewSize = [titleView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    NSDictionary *metrics = @{
                              @"titleViewWidth": @(titleViewSize.width),
                              @"titleViewHeight": @(titleViewSize.height),
                              @"sm": @(10.0f),  // side margin
                              @"separatorLineHeight": @(1.0f / scale),
                              @"faderSeparatorSpace": @(9.0f + 1.0f / scale),
                              };

    [contentsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(sm)-[titleView(titleViewWidth)]-(>=10)-[activeView]-(sm)-|" options:NSLayoutFormatAlignAllCenterY metrics:metrics views:layoutViews]];
    [contentsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(sm)-[faderView]-(sm)-|" options:0 metrics:metrics views:layoutViews]];
    [contentsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(sm)-[titleFaderSeparatorView]-(sm)-|" options:0 metrics:metrics views:layoutViews]];

    [contentsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(sm)-[faderView]-(faderSeparatorSpace)-[titleFaderSeparatorView(separatorLineHeight)]-(>=5)-[titleView(titleViewHeight)]-(>=sm)-|" options:0 metrics:metrics views:layoutViews]];
    [contentsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[titleFaderSeparatorView]-(>=5)-[activeView]-(>=sm)-|" options:0 metrics:metrics views:layoutViews]];
}

- (void)configureLayoutForWideLayoutStyle
{
    UIView *activeView = self.activeView;
    UIView *contentsView = self.contentsView;
    UIView *faderView = self.faderView;
    UIView *titleView = self.titleView;

    NSDictionary *layoutViews = NSDictionaryOfVariableBindings(activeView, faderView, titleView);

    CGSize titleViewSize = [titleView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    NSDictionary *metrics = @{
                              @"titleViewWidth": @(titleViewSize.width),
                              @"titleViewHeight": @(titleViewSize.height),
                              @"sm": @(10.0f),  // side margin
                              };

    [contentsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(sm)-[titleView(titleViewWidth)]-(20@751,>=20)-[faderView(<=340)]-(20@751,>=20)-[activeView]-(sm)-|" options:NSLayoutFormatAlignAllCenterY metrics:metrics views:layoutViews]];
    [contentsView addConstraint:[NSLayoutConstraint constraintWithItem:faderView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:faderView.superview attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0]];

    [contentsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=sm)-[faderView]-(>=sm)-|" options:0 metrics:metrics views:layoutViews]];
    [contentsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=sm)-[activeView]-(>=sm)-|" options:0 metrics:metrics views:layoutViews]];
    [contentsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=sm)-[titleView(titleViewHeight)]-(>=sm)-|" options:0 metrics:metrics views:layoutViews]];
}


#pragma mark - Subview Creation

- (DXRDynamicXrayConfigurationActiveView *)newActiveView
{
    DXRDynamicXrayConfigurationActiveView *activeView = [[DXRDynamicXrayConfigurationActiveView alloc] initWithFrame:CGRectZero];
    activeView.translatesAutoresizingMaskIntoConstraints = NO;
    return activeView;
}

- (DXRDynamicXrayConfigurationTitleView *)newTitleView
{
    DXRDynamicXrayConfigurationTitleView *titleView = [[DXRDynamicXrayConfigurationTitleView alloc] initWithFrame:CGRectZero];
    titleView.translatesAutoresizingMaskIntoConstraints = NO;
    return titleView;
}

- (DXRDynamicXrayConfigurationFaderView *)newFaderView
{
    DXRDynamicXrayConfigurationFaderView *faderView = [[DXRDynamicXrayConfigurationFaderView alloc] initWithFrame:CGRectZero];
    faderView.translatesAutoresizingMaskIntoConstraints = NO;
    return faderView;
}

- (UIView *)newTitleFaderSeparatorView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor colorWithRed:0.192157f green:0.192157f blue:0.192157f alpha:1.0f];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    return view;
}

@end
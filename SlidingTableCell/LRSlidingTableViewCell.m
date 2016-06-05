//
//  LRSlidingTableViewCell.m
//  LRSlidingTableViewCell
//
//  Created by Luke Redpath on 5/26/2011.
//  Modified by Alexsander Akers on 1/20/2012.
//
//  Copyright 2011 LJR Software Limited. All rights reserved.
//

#import "LRSlidingTableViewCell.h"

@interface LRSlidingTableViewCell ()

@property (nonatomic) UISwipeGestureRecognizerDirection lastRecognizedDirection;

- (void) addSwipeGestureRecognizer: (UISwipeGestureRecognizerDirection) direction;

@end

@implementation LRSlidingTableViewCell

@synthesize delegate = _delegate;
@synthesize swipeDirection = _swipeDirection;
@synthesize lastRecognizedDirection = _lastRecognizedDirection;

- (BOOL) isBackgroundViewVisible
{
	return _backgroundViewVisible;
}

- (id) initWithStyle: (UITableViewCellStyle) style reuseIdentifier: (NSString *) reuseIdentifier
{
	if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
	{
		self.swipeDirection = LRSlidingTableViewCellSwipeDirectionRight;
		self.lastRecognizedDirection = UISwipeGestureRecognizerDirectionRight;
		
		/** Add a default empty background view to make it clear that it's all working */
		UIView *defaultBackgroundView = [[UIView alloc] initWithFrame: self.contentView.frame];
		defaultBackgroundView.backgroundColor = [UIColor darkGrayColor];
		self.backgroundView = defaultBackgroundView;
	}
	
	return self;
}
- (id) initWithCoder: (NSCoder *) decoder
{
	if ((self = [super initWithCoder: decoder]))
	{
		if (!self.swipeDirection) self.swipeDirection = LRSlidingTableViewCellSwipeDirectionRight;
		if (!self.lastRecognizedDirection) self.lastRecognizedDirection = UISwipeGestureRecognizerDirectionRight;
	}
	
	return self;
}

- (void) addSwipeGestureRecognizer: (UISwipeGestureRecognizerDirection) direction;
{
	UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget: self action: @selector(handleSwipe:)];
	swipeGesture.direction = direction;
	
	[self addGestureRecognizer: swipeGesture];
}
- (void) handleSwipe: (UISwipeGestureRecognizer *) gesture
{
	if (_backgroundViewVisible)
		return;
	
	BOOL canSwipe = YES;
	if (self.delegate && [self.delegate respondsToSelector: @selector(slidingTableViewCellShouldSwipe:)])
		canSwipe = [self.delegate slidingTableViewCellShouldSwipe: self];
	
	if (!canSwipe)
		return;
	
	[self slideOutContentView: gesture.direction];
}
- (void) layoutSubviews
{
	[super layoutSubviews];
	
	self.contentView.frame = self.bounds;
}
- (void) setSwipeDirection: (LRSlidingTableViewCellSwipeDirection) direction
{
	if (_swipeDirection == direction)
		return;
	
	_swipeDirection = direction;
	
	NSArray *existingGestures = [self gestureRecognizers];
	[existingGestures enumerateObjectsUsingBlock: ^(UIGestureRecognizer *gesture, NSUInteger idx, BOOL *stop) {
		[self removeGestureRecognizer: gesture];
	}];
	
	switch (_swipeDirection)
	{
		case LRSlidingTableViewCellSwipeDirectionLeft:
			[self addSwipeGestureRecognizer: UISwipeGestureRecognizerDirectionLeft];
			break;
			
		case LRSlidingTableViewCellSwipeDirectionRight:
			[self addSwipeGestureRecognizer: UISwipeGestureRecognizerDirectionRight];
			break;
			
		case LRSlidingTableViewCellSwipeDirectionBoth:
			[self addSwipeGestureRecognizer: UISwipeGestureRecognizerDirectionLeft];
			[self addSwipeGestureRecognizer: UISwipeGestureRecognizerDirectionRight];
			break;
			
		default:
			break;
	}
}

#pragma mark Sliding content view

#define kBOUNCE_DISTANCE 20.0

void LR_offsetView(UIView *view, CGFloat offsetX, CGFloat offsetY);
void LR_offsetView(UIView *view, CGFloat offsetX, CGFloat offsetY)
{
	view.frame = CGRectOffset(view.frame, offsetX, offsetY);
}

- (void) slideInContentView
{
	if (!_backgroundViewVisible)
		return;
	
	CGFloat offsetX, bounceDistance;
	
	switch (self.lastRecognizedDirection)
	{
		case UISwipeGestureRecognizerDirectionLeft:
			offsetX = self.contentView.frame.size.width;
			bounceDistance = -kBOUNCE_DISTANCE;
			break;
			
		case UISwipeGestureRecognizerDirectionRight:
			offsetX = -self.contentView.frame.size.width;
			bounceDistance = kBOUNCE_DISTANCE;
			break;
			
		default:
			@throw [NSException exceptionWithName: NSInternalInconsistencyException reason: @"Unhandled gesture direction" userInfo: [NSDictionary dictionaryWithObject: [NSNumber numberWithInt: self.lastRecognizedDirection] forKey: @"lastRecognizedDirection"]];
			break;
	}
	
	[UIView animateWithDuration: 0.1 delay: 0 options: (UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction) animations: ^{
		LR_offsetView(self.contentView, offsetX, 0);
	} completion: ^(BOOL finished) {
		 [UIView animateWithDuration: 0.1 delay: 0 options: UIViewAnimationCurveLinear animations: ^{
			 LR_offsetView(self.contentView, bounceDistance, 0);
		 } completion: ^(BOOL finished) {
			 [UIView animateWithDuration: 0.1 delay: 0 options: UIViewAnimationCurveLinear animations: ^{
				 LR_offsetView(self.contentView, -bounceDistance, 0);
			 } completion: ^(BOOL finished) {
				 _backgroundViewVisible = NO;
			 }];
		 }];
	}];
}
- (void) slideOutContentView: (UISwipeGestureRecognizerDirection) direction
{
	if (_backgroundViewVisible)
		return;
	
	self.lastRecognizedDirection = direction;
	
	CGFloat offsetX;
	
	switch (direction)
	{
		case UISwipeGestureRecognizerDirectionLeft:
			offsetX = -self.contentView.frame.size.width;
			break;
			
		case UISwipeGestureRecognizerDirectionRight:
			offsetX = self.contentView.frame.size.width;
			break;
			
		default:
			@throw [NSException exceptionWithName: NSInternalInconsistencyException reason: @"Unhandled gesture direction" userInfo: [NSDictionary dictionaryWithObject: [NSNumber numberWithInt: self.lastRecognizedDirection] forKey: @"lastRecognizedDirection"]];
			break;
	}

	[UIView animateWithDuration: 0.2 delay: 0 options: UIViewAnimationOptionCurveEaseOut animations: ^{
		LR_offsetView(self.contentView, offsetX, 0);
	} completion: ^(BOOL finished) {
		_backgroundViewVisible = YES;
		[self.delegate slidingTableViewCellDidReceiveSwipe: self];
	}];
}

@end

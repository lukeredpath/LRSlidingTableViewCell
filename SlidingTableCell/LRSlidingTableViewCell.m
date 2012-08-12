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
- (void)addSwipeGestureRecognizer:(UISwipeGestureRecognizerDirection)direction;
@end

@implementation LRSlidingTableViewCell

@synthesize delegate = _delegate;
@synthesize swipeDirection = _swipeDirection;
@synthesize lastRecognizedDirection = _lastRecognizedDirection;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
		self.swipeDirection = LRSlidingTableViewCellSwipeDirectionRight;
		self.lastRecognizedDirection = UISwipeGestureRecognizerDirectionRight;
        
		// Add a default empty background view to make it clear that it's all working
		self.backgroundView = [[UIView alloc] initWithFrame:self.contentView.frame];
		self.backgroundView.backgroundColor = [UIColor darkGrayColor];
        
        // Set the backgroundView to hidden. This stops it from displaying behind selections.
        self.backgroundView.hidden = YES;
	}
	
	return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
	if ((self = [super initWithCoder:decoder])) {
		if (!self.swipeDirection)
            self.swipeDirection = LRSlidingTableViewCellSwipeDirectionRight;
		if (!self.lastRecognizedDirection)
            self.lastRecognizedDirection = UISwipeGestureRecognizerDirectionRight;
	}
	return self;
}

- (BOOL)isBackgroundViewVisible
{
    return !self.backgroundView.hidden;
}

- (void)addSwipeGestureRecognizer:(UISwipeGestureRecognizerDirection)direction;
{
	UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
	swipeGesture.direction = direction;
	
	[self addGestureRecognizer:swipeGesture];
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)gesture
{
	if (!self.backgroundView.hidden)
		return;
	
	BOOL canSwipe = YES;
	if (self.delegate && [self.delegate respondsToSelector:@selector(slidingTableViewCellShouldSwipe:)])
		canSwipe = [self.delegate slidingTableViewCellShouldSwipe:self];
	
	if (!canSwipe)
		return;
	
	[self slideOutContentView:gesture.direction];
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	self.contentView.frame = self.bounds;
}

- (void)setSwipeDirection:(LRSlidingTableViewCellSwipeDirection)direction
{
	if (_swipeDirection == direction)
		return;
	
	_swipeDirection = direction;
	
	NSArray *existingGestures = [self gestureRecognizers];
	[existingGestures enumerateObjectsUsingBlock: ^(UIGestureRecognizer *gesture, NSUInteger idx, BOOL *stop) {
		[self removeGestureRecognizer:gesture];
	}];
	
	switch (_swipeDirection)
	{
		case LRSlidingTableViewCellSwipeDirectionLeft:
			[self addSwipeGestureRecognizer:UISwipeGestureRecognizerDirectionLeft];
			break;
			
		case LRSlidingTableViewCellSwipeDirectionRight:
			[self addSwipeGestureRecognizer:UISwipeGestureRecognizerDirectionRight];
			break;
			
		case LRSlidingTableViewCellSwipeDirectionBoth:
			[self addSwipeGestureRecognizer:UISwipeGestureRecognizerDirectionLeft];
			[self addSwipeGestureRecognizer:UISwipeGestureRecognizerDirectionRight];
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

- (void)slideInContentView
{
	if (self.backgroundView.hidden)
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
			@throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Unhandled gesture direction" userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt: self.lastRecognizedDirection] forKey:@"lastRecognizedDirection"]];
			break;
	}
	
	[UIView animateWithDuration:0.1 delay:0 options:(UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction) animations: ^{
		LR_offsetView(self.contentView, offsetX, 0);
	} completion:^(BOOL finished) {
		 [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationCurveLinear animations: ^{
			 LR_offsetView(self.contentView, bounceDistance, 0);
		 } completion:^(BOOL finished) {
			 [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationCurveLinear animations: ^{
				 LR_offsetView(self.contentView, -bounceDistance, 0);
			 } completion:^(BOOL finished) {
				 self.backgroundView.hidden = YES;
			 }];
		 }];
	}];
}

- (void)slideOutContentView:(UISwipeGestureRecognizerDirection)direction
{
	if (!self.backgroundView.hidden)
		return;
	
    self.backgroundView.hidden = NO;
    
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
			@throw [NSException exceptionWithName: NSInternalInconsistencyException reason:@"Unhandled gesture direction" userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:self.lastRecognizedDirection] forKey:@"lastRecognizedDirection"]];
			break;
	}

	[UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations: ^{
		LR_offsetView(self.contentView, offsetX, 0);
	} completion: ^(BOOL finished) {
		[self.delegate slidingTableViewCellDidReceiveSwipe: self];
	}];
}

@end

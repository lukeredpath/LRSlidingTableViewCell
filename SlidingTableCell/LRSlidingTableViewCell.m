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
@property (nonatomic, getter = isBackgroundViewVisible) BOOL backgroundViewVisible;
@property (nonatomic, getter = isSelectionAnimating) BOOL selectionAnimating;
@property (nonatomic) UISwipeGestureRecognizerDirection lastRecognizedDirection;
- (void)addSwipeGestureRecognizer:(UISwipeGestureRecognizerDirection)direction;
@end

@implementation LRSlidingTableViewCell

@synthesize selectionAnimating = _selectionAnimating;
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
        
        // Keep track of the selection style
        self.userSelectionStyle = style;
        
        // Set our backgroundView to be hidden
        self.backgroundViewVisible = NO;
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

- (void)selectionStoppedAnimating
{
    self.selectionAnimating = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (animated) {
        self.selectionAnimating = YES;
        // Hard coded selection animation delay
        [self performSelector:@selector(selectionStoppedAnimating) withObject:nil afterDelay:0.5];
    }
}

- (void)setBackgroundViewVisible:(BOOL)backgroundViewVisible
{
    _backgroundViewVisible = backgroundViewVisible;
    // Ensure the backgroundView doesn't appear behind selections
    self.backgroundView.hidden = !backgroundViewVisible;
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
    
    if (self.selectionAnimating)
        canSwipe = NO;
    	
	if (!canSwipe)
		return;
    
	[self slideOutContentView:gesture.direction];
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
    if (self.backgroundViewVisible) {
        CGFloat offsetX = self.contentView.frame.size.width;
        LR_offsetView(self.contentView, offsetX, 0);
    } else {
        self.contentView.frame = self.bounds;
    }
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
	if (!self.backgroundViewVisible)
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
				 self.backgroundViewVisible = NO;
			 }];
		 }];
	}];
}

- (void)slideOutContentView:(UISwipeGestureRecognizerDirection)direction
{
	if (self.backgroundViewVisible)
		return;
    
    // Deselect the cell if it's selected
    [self setSelected:NO animated:NO];
    
    // Show the background view
    self.backgroundViewVisible = YES;

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
		[self.delegate slidingTableViewCellDidReceiveSwipe:self];
	}];
}

@end

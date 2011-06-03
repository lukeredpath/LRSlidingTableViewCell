//
//  SlidingTableCell.m
//  SlidingTableCell
//
//  Created by Luke Redpath on 26/05/2011.
//  Copyright 2011 LJR Software Limited. All rights reserved.
//

#import "LRSlidingTableViewCell.h"

@interface LRSlidingTableViewCell ()
- (void)addSwipeGestureRecognizer:(UISwipeGestureRecognizerDirection)direction;
@end

@implementation LRSlidingTableViewCell

@synthesize delegate;
@synthesize swipeDirection;
@synthesize lastGestureRecognized;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
    
    self.swipeDirection = LRSlidingTableViewCellSwipeDirectionRight;

    /** Add a default empty background view to make it clear that it's all working */
    UIView *defaultBackgroundView = [[UIView alloc] initWithFrame:self.contentView.frame];
    defaultBackgroundView.backgroundColor = [UIColor darkGrayColor];
    self.backgroundView = defaultBackgroundView;
    [defaultBackgroundView release];
  }
  
  return self;
}

- (void)dealloc
{
  [lastGestureRecognized release];
  [super dealloc];
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)gesture
{
  [self setLastGestureRecognized:gesture];
  [self slideOutContentView];
  [self.delegate cellDidReceiveSwipe:self];
}

- (void)setSwipeDirection:(LRSlidingTableViewCellSwipeDirection)direction
{
  swipeDirection = direction;
  
  NSArray *existingGestures = [self gestureRecognizers];
  for (UIGestureRecognizer *gesture in existingGestures) {
    [self removeGestureRecognizer:gesture];
  }
  
  switch (swipeDirection) {
    case LRSlidingTableViewCellSwipeDirectionLeft:
      [self addSwipeGestureRecognizer:UISwipeGestureRecognizerDirectionLeft];
      break;
    case LRSlidingTableViewCellSwipeDirectionRight:
      [self addSwipeGestureRecognizer:UISwipeGestureRecognizerDirectionRight];
      break;
    case LRSlidingTableViewCellSwipeDirectionBoth:
      [self addSwipeGestureRecognizer:UISwipeGestureRecognizerDirectionLeft];
      [self addSwipeGestureRecognizer:UISwipeGestureRecognizerDirectionRight];
    default:
      break;
  }
}

- (void)addSwipeGestureRecognizer:(UISwipeGestureRecognizerDirection)direction;
{
  UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
  swipeGesture.direction = direction;
  [self addGestureRecognizer:swipeGesture];
  [swipeGesture release];
}


#pragma mark Sliding content view

#define kBOUNCE_DISTANCE 20.0

void LR_offsetView(UIView *view, CGFloat offsetX, CGFloat offsetY)
{
  view.frame = CGRectOffset(view.frame, offsetX, offsetY);
}

- (void)slideOutContentView;
{
  CGFloat offsetX;
  
  switch (self.lastGestureRecognized.direction) {
    case UISwipeGestureRecognizerDirectionLeft:
      offsetX = -self.contentView.frame.size.width;
      break;
    case UISwipeGestureRecognizerDirectionRight:
      offsetX = self.contentView.frame.size.width;
      break;
    default:
      @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Unhandled gesture direction" userInfo:[NSDictionary dictionaryWithObject:self.lastGestureRecognized forKey:@"lastGestureRecognized"]];
      break;
  }

  [UIView animateWithDuration:0.2 
                        delay:0 
                      options:UIViewAnimationOptionCurveEaseOut 
                   animations:^{ LR_offsetView(self.contentView, offsetX, 0); } 
                   completion:NULL];
}

- (void)slideInContentView;
{
  CGFloat offsetX, bounceDistance;
  
  switch (self.lastGestureRecognized.direction) {
    case UISwipeGestureRecognizerDirectionLeft:
      offsetX = self.contentView.frame.size.width;
      bounceDistance = -kBOUNCE_DISTANCE;
      break;
    case UISwipeGestureRecognizerDirectionRight:
      offsetX = -self.contentView.frame.size.width;
      bounceDistance = kBOUNCE_DISTANCE;
      break;
    default:
      @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Unhandled gesture direction" userInfo:[NSDictionary dictionaryWithObject:self.lastGestureRecognized forKey:@"lastGestureRecognized"]];
      break;
  }
  
  [UIView animateWithDuration:0.1
                        delay:0 
                      options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionAllowUserInteraction 
                   animations:^{ LR_offsetView(self.contentView, offsetX, 0); } 
                   completion:^(BOOL f) {
                   
    [UIView animateWithDuration:0.1 delay:0 
                        options:UIViewAnimationCurveLinear
                     animations:^{ LR_offsetView(self.contentView, bounceDistance, 0); } 
                     completion:^(BOOL f) {                     

         [UIView animateWithDuration:0.1 delay:0 
                             options:UIViewAnimationCurveLinear
                          animations:^{ LR_offsetView(self.contentView, -bounceDistance, 0); } 
                          completion:NULL];
       }
    ];   
  }];
}

@end

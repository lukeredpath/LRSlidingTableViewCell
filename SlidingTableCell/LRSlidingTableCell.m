//
//  SlidingTableCell.m
//  SlidingTableCell
//
//  Created by Luke Redpath on 26/05/2011.
//  Copyright 2011 LJR Software Limited. All rights reserved.
//

#import "LRSlidingTableCell.h"


@implementation LRSlidingTableCell

@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
    
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:swipeGesture];
    [swipeGesture release];

    UIView *backgroundView = [[UIView alloc] initWithFrame:self.contentView.frame];
    backgroundView.backgroundColor = [UIColor darkGrayColor];
    self.backgroundView = backgroundView;
    [backgroundView release];
  }
  
  return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{
  [super dealloc];
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)gesture
{
  [self slideOutContentView];
  [self.delegate cellDidReceiveSwipe:self];
}

#pragma mark Sliding content view

#define kBOUNCE_DISTANCE 15.0

void offsetView(UIView *view, CGFloat offsetX, CGFloat offsetY)
{
  view.frame = CGRectOffset(view.frame, offsetX, offsetY);
}

- (void)slideOutContentView;
{
  [UIView animateWithDuration:0.2 
                        delay:0 
                      options:UIViewAnimationOptionCurveEaseOut 
                   animations:^{ offsetView(self.contentView, self.contentView.frame.size.width, 0); } 
                   completion:NULL];
}

- (void)slideInContentView;
{
  [UIView animateWithDuration:0.1
                        delay:0 
                      options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionAllowUserInteraction 
                   animations:^{ offsetView(self.contentView, -self.contentView.frame.size.width, 0); } 
                   completion:^(BOOL f) {
                   
    [UIView animateWithDuration:0.1 delay:0 
                        options:UIViewAnimationCurveLinear
                     animations:^{ offsetView(self.contentView, kBOUNCE_DISTANCE, 0); } 
                     completion:^(BOOL f) {                     

         [UIView animateWithDuration:0.1 delay:0 
                             options:UIViewAnimationCurveLinear
                          animations:^{ offsetView(self.contentView, -kBOUNCE_DISTANCE, 0); } 
                          completion:NULL];
       }
    ];   
  }];
}

@end

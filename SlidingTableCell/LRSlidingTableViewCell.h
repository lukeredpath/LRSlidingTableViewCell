//
//  SlidingTableCell.h
//  SlidingTableCell
//
//  Created by Luke Redpath on 26/05/2011.
//  Copyright 2011 LJR Software Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LRSlidingTableViewCell;

typedef enum {
  LRSlidingTableViewCellSwipeDirectionRight = 0,
  LRSlidingTableViewCellSwipeDirectionLeft,
  LRSlidingTableViewCellSwipeDirectionBoth,
  LRSlidingTableViewCellSwipeDirectionNone,
} LRSlidingTableViewCellSwipeDirection;

@protocol LRSlidingTableViewCellDelegate <NSObject>
- (void)cellDidReceiveSwipe:(LRSlidingTableViewCell *)cell;
@end

@interface LRSlidingTableViewCell : UITableViewCell {
  id <LRSlidingTableViewCellDelegate> delegate;
}
@property (nonatomic, assign) id <LRSlidingTableViewCellDelegate> delegate;
@property (nonatomic, assign) LRSlidingTableViewCellSwipeDirection swipeDirection;
@property (nonatomic, retain) UISwipeGestureRecognizer *lastGestureRecognized;

/** Slides the content view out to the right to reveal the background view. */
- (void)slideOutContentView;

/** Slides the content view back in to cover the background view. */
- (void)slideInContentView;
@end

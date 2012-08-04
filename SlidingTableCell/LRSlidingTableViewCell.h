//
//  LRSlidingTableViewCell.h
//  LRSlidingTableViewCell
//
//  Created by Luke Redpath on 5/26/2011.
//  Modified by Alexsander Akers on 1/20/2012.
//
//  Copyright 2011 LJR Software Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LRSlidingTableViewCell;

typedef enum {
	LRSlidingTableViewCellSwipeDirectionNone = 0,
	LRSlidingTableViewCellSwipeDirectionRight = UISwipeGestureRecognizerDirectionRight,
	LRSlidingTableViewCellSwipeDirectionLeft = UISwipeGestureRecognizerDirectionLeft,
	LRSlidingTableViewCellSwipeDirectionBoth = LRSlidingTableViewCellSwipeDirectionRight | LRSlidingTableViewCellSwipeDirectionLeft
} LRSlidingTableViewCellSwipeDirection;

@protocol LRSlidingTableViewCellDelegate <NSObject>
- (void)slidingTableViewCellDidReceiveSwipe:(LRSlidingTableViewCell *)cell;
@optional
- (BOOL)slidingTableViewCellShouldSwipe:(LRSlidingTableViewCell *)cell;
@end

@interface LRSlidingTableViewCell : UITableViewCell
{
	__weak id <LRSlidingTableViewCellDelegate> _delegate;
	BOOL _backgroundViewVisible;
	LRSlidingTableViewCellSwipeDirection _swipeDirection;
	UISwipeGestureRecognizerDirection _lastRecognizedDirection;
}

@property (nonatomic) LRSlidingTableViewCellSwipeDirection swipeDirection;
@property (nonatomic, weak) id<LRSlidingTableViewCellDelegate> delegate;

/** A Boolean indicator of whether the background view is visible. */
- (BOOL)isBackgroundViewVisible;

/** Slides the content view out to the right or left to reveal the background view. */
- (void)slideOutContentView: (UISwipeGestureRecognizerDirection) direction;

/** Slides the content view back in to cover the background view. */
- (void)slideInContentView;

@end

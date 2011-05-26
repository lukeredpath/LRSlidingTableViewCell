//
//  SlidingTableCell.h
//  SlidingTableCell
//
//  Created by Luke Redpath on 26/05/2011.
//  Copyright 2011 LJR Software Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LRSlidingTableViewCell;

@protocol LRSlidingTableViewCellDelegate <NSObject>
- (void)cellDidReceiveSwipe:(LRSlidingTableViewCell *)cell;
@end

@interface LRSlidingTableViewCell : UITableViewCell {
  id <LRSlidingTableViewCellDelegate> delegate;
}
@property (nonatomic, assign) id <LRSlidingTableViewCellDelegate> delegate;

/** Slides the content view out to the right to reveal the background view. */
- (void)slideOutContentView;

/** Slides the content view back in to cover the background view. */
- (void)slideInContentView;
@end

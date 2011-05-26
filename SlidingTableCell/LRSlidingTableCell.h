//
//  SlidingTableCell.h
//  SlidingTableCell
//
//  Created by Luke Redpath on 26/05/2011.
//  Copyright 2011 LJR Software Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LRSlidingTableCell;

@protocol LRSlidingTableCellDelegate <NSObject>
- (void)cellDidReceiveSwipe:(LRSlidingTableCell *)cell;
@end

@interface LRSlidingTableCell : UITableViewCell {
  id <LRSlidingTableCellDelegate> delegate;
}
@property (nonatomic, assign) id <LRSlidingTableCellDelegate> delegate;

- (void)slideOutContentView;
- (void)slideInContentView;
@end

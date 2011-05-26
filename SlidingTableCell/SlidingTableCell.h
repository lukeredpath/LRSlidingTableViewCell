//
//  SlidingTableCell.h
//  SlidingTableCell
//
//  Created by Luke Redpath on 26/05/2011.
//  Copyright 2011 LJR Software Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SlidingTableCell;

@protocol SlidingTableCellDelegate <NSObject>
- (void)cellDidReceiveSwipe:(SlidingTableCell *)cell;
@end

@interface SlidingTableCell : UITableViewCell {
  id <SlidingTableCellDelegate> delegate;
}
@property (nonatomic, assign) id <SlidingTableCellDelegate> delegate;

- (void)slideOutContentView;
- (void)slideInContentView;
@end

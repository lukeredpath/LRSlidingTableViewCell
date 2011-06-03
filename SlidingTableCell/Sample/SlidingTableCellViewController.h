//
//  SlidingTableCellViewController.h
//  SlidingTableCell
//
//  Created by Luke Redpath on 26/05/2011.
//  Copyright 2011 LJR Software Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LRSlidingTableViewCell.h"

@interface SlidingTableCellViewController : UITableViewController <LRSlidingTableViewCellDelegate> {
  LRSlidingTableViewCell *currentlyActiveSlidingCell;
}
@property (nonatomic, retain) LRSlidingTableViewCell *currentlyActiveSlidingCell;
@end

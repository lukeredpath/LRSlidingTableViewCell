//
//  SlidingTableCellViewController.h
//  SlidingTableCell
//
//  Created by Luke Redpath on 26/05/2011.
//  Copyright 2011 LJR Software Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LRSlidingTableCell.h"

@interface SlidingTableCellViewController : UITableViewController <LRSlidingTableCellDelegate> {
  LRSlidingTableCell *currentlyActiveSlidingCell;
}
@property (nonatomic, retain) LRSlidingTableCell *currentlyActiveSlidingCell;
@end

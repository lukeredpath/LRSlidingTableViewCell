//
//  SlidingTableCellViewController.h
//  SlidingTableCell
//
//  Created by Luke Redpath on 26/05/2011.
//  Copyright 2011 LJR Software Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlidingTableCell.h"

@interface SlidingTableCellViewController : UITableViewController <SlidingTableCellDelegate> {
  SlidingTableCell *currentlyActiveSlidingCell;
}
@property (nonatomic, retain) SlidingTableCell *currentlyActiveSlidingCell;
@end

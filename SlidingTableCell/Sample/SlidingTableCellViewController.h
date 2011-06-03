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
}
@property (nonatomic, retain) LRSlidingTableViewCell *currentlyActiveSlidingCell;
@property (nonatomic, retain) IBOutlet UISegmentedControl *swipeDirectionSegmentedControl;
@property (nonatomic, assign) LRSlidingTableViewCellSwipeDirection swipeDirection;

- (IBAction)handleSegmentedControlSelection:(id)sender;
@end

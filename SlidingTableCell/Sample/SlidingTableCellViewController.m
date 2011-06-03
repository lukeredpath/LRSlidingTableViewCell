//
//  SlidingTableCellViewController.m
//  SlidingTableCell
//
//  Created by Luke Redpath on 26/05/2011.
//  Copyright 2011 LJR Software Limited. All rights reserved.
//

#import "SlidingTableCellViewController.h"

@implementation SlidingTableCellViewController

@synthesize currentlyActiveSlidingCell;
@synthesize swipeDirectionSegmentedControl;
@synthesize swipeDirection;

- (void)dealloc
{
  [currentlyActiveSlidingCell release];
  [super dealloc];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.navigationItem.prompt = @"Use the toolbar to change swipe direction";
  
  UIBarItem *controlItem = [[UIBarButtonItem alloc] initWithCustomView:self.swipeDirectionSegmentedControl];
  [self setToolbarItems:[NSArray arrayWithObject:controlItem]];
  [controlItem release];
}

- (IBAction)handleSegmentedControlSelection:(UISegmentedControl *)sender;
{
  self.swipeDirection = (LRSlidingTableViewCellSwipeDirection)sender.selectedSegmentIndex;
  self.currentlyActiveSlidingCell = nil;

  [self.tableView reloadData];
}

#pragma mark -

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 60.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *identifier = @"CELL_IDENTIFIER";
  
  LRSlidingTableViewCell *cell = (LRSlidingTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
  
  if (cell == nil) {
    cell = [[[LRSlidingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
  }
  
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  cell.contentView.backgroundColor = [UIColor whiteColor];
  cell.textLabel.text = [NSString stringWithFormat:@"Cell %d", indexPath.row];
  cell.swipeDirection = self.swipeDirection;
  cell.delegate = self;
  
  return cell;
}

/** Store a reference to the cell that has been swiped.
 *
 *  This allows us to slide the cell's content back in again if the user
 *  starts dragging the table view or swipes a different cell. 
 */
- (void)cellDidReceiveSwipe:(LRSlidingTableViewCell *)cell
{
  self.currentlyActiveSlidingCell = cell;
}

/** Any swiped cell should be reset when we start to scroll. */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
  self.currentlyActiveSlidingCell = nil;
}

/** Whenever the current active sliding cell changes (or is set to nil)
  * the existing one should be reset by calling it's slideInContentView method. */
- (void)setCurrentlyActiveSlidingCell:(LRSlidingTableViewCell *)cell
{
  [currentlyActiveSlidingCell slideInContentView];
  [currentlyActiveSlidingCell autorelease];
  currentlyActiveSlidingCell = [cell retain];
}

@end

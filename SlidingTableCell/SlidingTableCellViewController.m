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

- (void)dealloc
{
  [currentlyActiveSlidingCell release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
  
  SlidingTableCell *cell = (SlidingTableCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
  
  if (cell == nil) {
    cell = [[[SlidingTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
  }
  
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  cell.contentView.backgroundColor = [UIColor whiteColor];
  cell.textLabel.text = [NSString stringWithFormat:@"Cell %d", indexPath.row];
  cell.delegate = self;
  
  return cell;
}

- (void)cellDidReceiveSwipe:(SlidingTableCell *)cell
{
  self.currentlyActiveSlidingCell = cell;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
  self.currentlyActiveSlidingCell = nil;
}

- (void)setCurrentlyActiveSlidingCell:(SlidingTableCell *)cell
{
  [currentlyActiveSlidingCell slideInContentView];
  [currentlyActiveSlidingCell autorelease];
  currentlyActiveSlidingCell = [cell retain];
}

@end

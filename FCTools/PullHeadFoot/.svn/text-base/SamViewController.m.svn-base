//
//  SamViewController.m
//  SamPullRefreshAndLoad
//
//  Created by Sam on 14-7-14.
//  Copyright (c) 2014年 HelloWorld. All rights reserved.
//

#import "SamViewController.h"

@interface SamViewController ()
@property (nonatomic, strong) NSMutableArray *testArray;

@end

@implementation SamViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.testArray = [[NSMutableArray alloc] init];
    
    self.pullVC = [[SamPullVC alloc] init];
    [self addChildViewController:self.pullVC];
    self.pullVC.delegate = self;
    self.pullVC.targetTableView = self.tableView;
    self.pullVC.uniqueTimekey = @"Key";
    
    [self.pullVC setup];
    
    [self addSomethingToArray];
    
}

- (void)addSomethingToArray
{
    for(int i = 0; i < 15; i++)
    {
        [self.testArray addObject:@"Hello OOO"];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.testArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        cell.backgroundColor = [UIColor orangeColor];
    }
    
    cell.textLabel.text = [self.testArray objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - SamPullDelegate

- (void)headViewBeginUpdate:(SamPullVC *)pullVC
{
    NSLog(@"Sam headViewBeginUpdate");
    [self refreshDone];
}

- (void)footViewBeginUpdate:(SamPullVC *)pullVC
{
    NSLog(@"footViewBeginUpdate");
    [self loadMoreDone];
}

#pragma mark - IBAction

- (IBAction)tigger:(id)sender {
//    [self.pullVC headViewTriggeUpdateManual];
    [self.pullVC footViewTriggeUpdateManual];
}

- (void)refreshDone
{
        [self.testArray removeAllObjects];
        [self addSomethingToArray];
        [self.tableView reloadData];
        
        [self.pullVC headViewUpdateDone];
    
}

- (void)loadMoreDone
{
        [self addSomethingToArray];
        [self.tableView reloadData];
        [self.pullVC footViewUpdateDoneHaveMoreData:YES];
    
}
@end

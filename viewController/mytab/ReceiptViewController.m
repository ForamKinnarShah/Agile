//
//  ReceiptViewController.m
//  HERES2U
//
//  Created by agilepc97 on 4/15/13.
//  Copyright (c) 2013 Paul Amador. All rights reserved.
//

#import "ReceiptViewController.h"

@interface ReceiptViewController ()

@end

@implementation ReceiptViewController
@synthesize arrayData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Receipt";
    self.navigationController.navigationBar.topItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_small.png"]];
    
  //  NSLog(@"arrayData : %@",arrayData);
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell = nil;
    if(cell==nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        if(indexPath.row==0){
            UILabel *lblTransactionId = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 140, 30)];
            [lblTransactionId setText:[NSString stringWithFormat:@"Transaction ID"]];
            [lblTransactionId setFont:[UIFont boldSystemFontOfSize:15.0]];
            lblTransactionId.textColor = [UIColor blackColor];
            lblTransactionId.backgroundColor = [UIColor clearColor];
            lblTransactionId.textAlignment  = NSTextAlignmentLeft;
            [cell addSubview:lblTransactionId];
            
            UILabel *lblTransactionId1 = [[UILabel alloc] initWithFrame:CGRectMake(125, 5, 175, 30)];
            [lblTransactionId1 setText:[NSString stringWithFormat:@"%@",[arrayData objectAtIndex:0]]];
            [lblTransactionId1 setFont:[UIFont systemFontOfSize:15.0]];
            lblTransactionId1.textColor = [UIColor blueColor];
            lblTransactionId1.backgroundColor = [UIColor clearColor];
            lblTransactionId1.textAlignment = NSTextAlignmentRight;
            [cell addSubview:lblTransactionId1];
        }
        else if(indexPath.row==1){
            UILabel *lblSenderName = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 150, 30)];
            [lblSenderName setText:[NSString stringWithFormat:@"Sender Name"]];
            [lblSenderName setFont:[UIFont boldSystemFontOfSize:15.0]];
            lblSenderName.textColor = [UIColor blackColor];
            lblSenderName.backgroundColor = [UIColor clearColor];
            lblSenderName.textAlignment  = NSTextAlignmentLeft;
            [cell addSubview:lblSenderName];
            
            UILabel *lblSenderName1 = [[UILabel alloc] initWithFrame:CGRectMake(125, 5, 175, 30)];
            [lblSenderName1 setText:[NSString stringWithFormat:@"%@",[arrayData objectAtIndex:1]]];
            [lblSenderName1 setFont:[UIFont systemFontOfSize:15.0]];
            lblSenderName1.textColor = [UIColor blueColor];
            lblSenderName1.backgroundColor = [UIColor clearColor];
            lblSenderName1.textAlignment = NSTextAlignmentRight;
            [cell addSubview:lblSenderName1];
        }
        else if(indexPath.row==2){
            UILabel *lblReceiverName = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 150, 30)];
            [lblReceiverName setText:[NSString stringWithFormat:@"Receiver Name"]];
            [lblReceiverName setFont:[UIFont boldSystemFontOfSize:15.0]];
            lblReceiverName.textColor = [UIColor blackColor];
            lblReceiverName.backgroundColor = [UIColor clearColor];
            lblReceiverName.textAlignment  = NSTextAlignmentLeft;
            [cell addSubview:lblReceiverName];
            
            UILabel *lblReceiverName1 = [[UILabel alloc] initWithFrame:CGRectMake(125, 5, 175, 30)];
            [lblReceiverName1 setText:[NSString stringWithFormat:@"%@",[arrayData objectAtIndex:2]]];
            [lblReceiverName1 setFont:[UIFont systemFontOfSize:15.0]];
            lblReceiverName1.textColor = [UIColor blueColor];
            lblReceiverName1.backgroundColor = [UIColor clearColor];
            lblReceiverName1.textAlignment = NSTextAlignmentRight;
            [cell addSubview:lblReceiverName1];
        }
        else if(indexPath.row==3){
            UILabel *lblLocation = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 90, 30)];
            [lblLocation setText:[NSString stringWithFormat:@"Location"]];
            [lblLocation setFont:[UIFont boldSystemFontOfSize:15.0]];
            lblLocation.textColor = [UIColor blackColor];
            lblLocation.backgroundColor = [UIColor clearColor];
            lblLocation.textAlignment  = NSTextAlignmentLeft;
            [cell addSubview:lblLocation];
            
            UILabel *lblLocation1 = [[UILabel alloc] initWithFrame:CGRectMake(125, 5, 175, 30)];
            [lblLocation1 setText:[NSString stringWithFormat:@"%@",[arrayData objectAtIndex:3]]];
            [lblLocation1 setFont:[UIFont systemFontOfSize:15.0]];
            lblLocation1.textColor = [UIColor blueColor];
            lblLocation1.backgroundColor = [UIColor clearColor];
            lblLocation1.textAlignment = NSTextAlignmentRight;
            [cell addSubview:lblLocation1];
        }
        else if(indexPath.row==4){
            UILabel *lblAmount = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 90, 30)];
            [lblAmount setText:[NSString stringWithFormat:@"Amount"]];
            [lblAmount setFont:[UIFont boldSystemFontOfSize:15.0]];
            lblAmount.textColor = [UIColor blackColor];
            lblAmount.backgroundColor = [UIColor clearColor];
            lblAmount.textAlignment  = NSTextAlignmentLeft;
            [cell addSubview:lblAmount];
            
            UILabel *lblAmount1 = [[UILabel alloc] initWithFrame:CGRectMake(125, 5, 175, 30)];
            [lblAmount1 setText:[NSString stringWithFormat:@"$%@",[arrayData objectAtIndex:4]]];
            [lblAmount1 setFont:[UIFont systemFontOfSize:15.0]];
            lblAmount1.textColor = [UIColor blueColor];
            lblAmount1.backgroundColor = [UIColor clearColor];
            lblAmount1.textAlignment = NSTextAlignmentRight;
            [cell addSubview:lblAmount1];
        }
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}



@end

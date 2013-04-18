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
    self.navigationController.navigationBar.topItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_small.png"]];
    
    NSLog(@"arrayData : %@",arrayData);
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
            UILabel *lblTransactionId = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 140, 30)];
            [lblTransactionId setText:[NSString stringWithFormat:@"TransactionID:"]];
            [lblTransactionId setFont:[UIFont systemFontOfSize:20.0]];
            lblTransactionId.textColor = [UIColor blackColor];
            [cell addSubview:lblTransactionId];

            UILabel *lblTransactionId1 = [[UILabel alloc] initWithFrame:CGRectMake(142, 5, 200, 30)];
            [lblTransactionId1 setText:[NSString stringWithFormat:@"%@",[arrayData objectAtIndex:0]]];
            [lblTransactionId1 setFont:[UIFont systemFontOfSize:20.0]];
            lblTransactionId1.textColor = [UIColor blackColor];
            [cell addSubview:lblTransactionId1];
        }
        else if(indexPath.row==1){
            UILabel *lblSenderName = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 150, 30)];
            [lblSenderName setText:[NSString stringWithFormat:@"SenderName:"]];
            [lblSenderName setFont:[UIFont systemFontOfSize:20.0]];
            lblSenderName.textColor = [UIColor blackColor];
            [cell addSubview:lblSenderName];
            
            UILabel *lblSenderName1 = [[UILabel alloc] initWithFrame:CGRectMake(155, 5, 200, 30)];
            [lblSenderName1 setText:[NSString stringWithFormat:@"%@",[arrayData objectAtIndex:1]]];
            [lblSenderName1 setFont:[UIFont systemFontOfSize:20.0]];
            lblSenderName1.textColor = [UIColor blackColor];
            [cell addSubview:lblSenderName1];
        }
        else if(indexPath.row==2){
            UILabel *lblReceiverName = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 150, 30)];
            [lblReceiverName setText:[NSString stringWithFormat:@"ReceiverName:"]];
            [lblReceiverName setFont:[UIFont systemFontOfSize:20.0]];
            lblReceiverName.textColor = [UIColor blackColor];
            [cell addSubview:lblReceiverName];
            
            UILabel *lblReceiverName1 = [[UILabel alloc] initWithFrame:CGRectMake(155, 5, 200, 30)];
            [lblReceiverName1 setText:[NSString stringWithFormat:@"%@",[arrayData objectAtIndex:2]]];
            [lblReceiverName1 setFont:[UIFont systemFontOfSize:20.0]];
            lblReceiverName1.textColor = [UIColor blackColor];
            [cell addSubview:lblReceiverName1];
        }
        else if(indexPath.row==3){
            UILabel *lblLocation = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 90, 30)];
            [lblLocation setText:[NSString stringWithFormat:@"Location:"]];
            [lblLocation setFont:[UIFont systemFontOfSize:20.0]];
            lblLocation.textColor = [UIColor blackColor];
            [cell addSubview:lblLocation];
            
            UILabel *lblLocation1 = [[UILabel alloc] initWithFrame:CGRectMake(92, 5, 200, 30)];
            [lblLocation1 setText:[NSString stringWithFormat:@"%@",[arrayData objectAtIndex:3]]];
            [lblLocation1 setFont:[UIFont systemFontOfSize:20.0]];
            lblLocation1.textColor = [UIColor blackColor];
            [cell addSubview:lblLocation1];
        }
        else if(indexPath.row==4){
            UILabel *lblAmount = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 90, 30)];
            [lblAmount setText:[NSString stringWithFormat:@"Amount:"]];
            [lblAmount setFont:[UIFont systemFontOfSize:20.0]];
            lblAmount.textColor = [UIColor blackColor];
            [cell addSubview:lblAmount];
            
            UILabel *lblAmount1 = [[UILabel alloc] initWithFrame:CGRectMake(92, 5, 200, 30)];
            [lblAmount1 setText:[NSString stringWithFormat:@"%@",[arrayData objectAtIndex:4]]];
            [lblAmount1 setFont:[UIFont systemFontOfSize:20.0]];
            lblAmount1.textColor = [UIColor blackColor];
            [cell addSubview:lblAmount1];
        }
        
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}



@end

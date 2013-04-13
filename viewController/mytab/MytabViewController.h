//
//  MytabViewController.h
//  HERES2U
//
//  Created by Paul Amador on 11/29/12.
//  Copyright (c) 2012 Paul Amador. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "phpCallerDelegate.h"
#import "phpCaller.h" 
#import "utilities.h" 
#import "ImageViewLoading.h"
#import "MyTabXmlParse.h"
#import "MyTabSent.h"
#import "MyTabUsed.h"

@interface MytabViewController : UIViewController <UITabBarControllerDelegate,UINavigationControllerDelegate, UIActionSheetDelegate, phpCallerDelegate>
{
    IBOutlet UISegmentedControl *segmented;
    IBOutlet UITableView *objTableView;
    int selectedSegment;
    
    MyTabXmlParse *myparser;
    MyTabSent *myTabSent;
    MyTabUsed *myTabUsed;
    BOOL isSent;
    BOOL isUsed;
}

@property(nonatomic,retain) phpCaller *caller;
@property(nonatomic,retain) utilities *util;
@property(nonatomic,retain) NSMutableArray *receivedItems;
@property(nonatomic,retain) NSMutableArray *sentItems;
@property(nonatomic,retain) NSMutableArray *usedItems; 
@property(nonatomic,retain) IBOutlet UIButton *defaultBtn;

//@property(nonatomic,retain)MyTabXmlParse *myparser;
@property(nonatomic,retain)NSMutableArray *arrayData;
@property(nonatomic,retain)NSMutableArray *arrayTransactionsID;
@property(nonatomic,retain)NSMutableArray *arrayLocationID;
@property(nonatomic,retain)NSMutableArray *arrayLocationImage;
@property(nonatomic,retain)NSMutableArray *arrayLocationName;
@property(nonatomic,retain)NSMutableArray *arrayMiles;
@property(nonatomic,retain)NSMutableArray *arraySenderID;
@property(nonatomic,retain)NSMutableArray *arraySenderName;
@property(nonatomic,retain)NSMutableArray *arrayPrice;
@property(nonatomic,retain)NSMutableArray *arrayStatus;

@property(nonatomic,retain)NSMutableArray *arrayData1;
@property(nonatomic,retain)NSMutableArray *arrayTransactionsID1;
@property(nonatomic,retain)NSMutableArray *arrayLocationID1;
@property(nonatomic,retain)NSMutableArray *arrayLocationImage1;
@property(nonatomic,retain)NSMutableArray *arrayLocationName1;
@property(nonatomic,retain)NSMutableArray *arrayMiles1;
@property(nonatomic,retain)NSMutableArray *arraySenderID1;
@property(nonatomic,retain)NSMutableArray *arraySenderName1;
@property(nonatomic,retain)NSMutableArray *arrayPrice1;
@property(nonatomic,retain)NSMutableArray *arrayStatus1;

@property(nonatomic,retain)NSMutableArray *arrayData2;
@property(nonatomic,retain)NSMutableArray *arrayTransactionsID2;
@property(nonatomic,retain)NSMutableArray *arrayLocationID2;
@property(nonatomic,retain)NSMutableArray *arrayLocationImage2;
@property(nonatomic,retain)NSMutableArray *arrayLocationName2;
@property(nonatomic,retain)NSMutableArray *arrayMiles2;
@property(nonatomic,retain)NSMutableArray *arraySenderID2;
@property(nonatomic,retain)NSMutableArray *arraySenderName2;
@property(nonatomic,retain)NSMutableArray *arrayPrice2;
@property(nonatomic,retain)NSMutableArray *arrayStatus2;


@end

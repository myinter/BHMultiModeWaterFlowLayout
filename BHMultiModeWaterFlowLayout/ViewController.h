//
//  ViewController.h
//  BHMultiModeWaterFlowLayout
//
//  Created by bighiung on 2020/8/12.
//  Copyright © 2020 bighiung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BHMultiModeWaterFlowLayout.h"

@interface ViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,BHMultiModeWaterFlowLayoutDelegate>
{
    __weak IBOutlet UICollectionView *_collectionView;
    __weak IBOutlet BHMultiModeWaterFlowLayout *_waterFlowLayout;
    
    NSMutableArray *_dataSource;
}

@end


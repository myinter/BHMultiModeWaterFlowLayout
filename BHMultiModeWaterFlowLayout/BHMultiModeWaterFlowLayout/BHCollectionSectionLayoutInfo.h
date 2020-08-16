//
//  BHCollectionSectionLayoutInfo.h
//  BHMultiModeWaterFlowLayout
//
//  Created by bighiung on 2020/8/12.
//  Copyright © 2020 bighiung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BHCollectionSectionLayoutInfo : NSObject

@property (nonatomic,assign) CGRect frameForHeader;

@property (nonatomic,assign) CGRect frameForFooter;

@property (nonatomic,assign) CGSize sizeForSection;

@property (nonatomic,strong) NSMutableArray<UICollectionViewLayoutAttributes *> *layoutAttributeForCells;

@end

NS_ASSUME_NONNULL_END

//
//  BHCollectionSectionLayoutInfo.m
//  BHMultiModeWaterFlowLayout
//
//  Created by bighiung on 2020/8/12.
//  Copyright © 2020 bighiung. All rights reserved.
//

#import "BHCollectionSectionLayoutInfo.h"

@implementation BHCollectionSectionLayoutInfo


-(NSMutableArray *)layoutAttributeForCells:(NSMutableArray *)object
{
    if (_layoutAttributeForCells == nil) {
        _layoutAttributeForCells = [NSMutableArray new];
    }
    return _layoutAttributeForCells;
}
@end

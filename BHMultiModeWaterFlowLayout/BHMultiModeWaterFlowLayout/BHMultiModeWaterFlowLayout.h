//
//  BHMultiModeWaterFlowLayout.h
//  BHMultiModeWaterFlowLayout
//
//  Created by bighiung on 2020/8/12.
//  Copyright © 2020 bighiung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BHCollectionSectionLayoutInfo.h"
typedef struct BHRowColumn {
    NSInteger row;
    NSInteger column;
    NSInteger section;
}BHRowColumn;
@class BHMultiModeWaterFlowLayout;
@protocol BHMultiModeWaterFlowLayoutDelegate <UICollectionViewDelegateFlowLayout>
@optional

/*
 * 用于指定某个section的列数，只有一列，就会化为列表
 * Return a section's columns count
 */
- (NSInteger)collectionView:(UICollectionView *_Nonnull)collectionView layout:(BHMultiModeWaterFlowLayout *_Nonnull)collectionViewLayout numOfColumnInSection:(NSInteger)section;
/*
* 某一个section中，同一行中不同列之间的最小距离
* Min spacing between two items in different columns in a same row for a section
*/

- (CGFloat)collectionView:(UICollectionView *_Nonnull)collectionView layout:(BHMultiModeWaterFlowLayout *_Nonnull)collectionViewLayout itemMinSpacingInSection:(NSInteger)section;
/*
* 某一个section中，同一列中不同行之间的距离
* Spacing between two items in different rows for a section
*/
- (CGFloat)collectionView:(UICollectionView *_Nonnull)collectionView layout:(BHMultiModeWaterFlowLayout *_Nonnull)collectionViewLayout lineSpacingInSection:(NSInteger)section;
@end

NS_ASSUME_NONNULL_BEGIN
@interface BHMultiModeWaterFlowLayout : UICollectionViewFlowLayout
{
    //各个section的总size
    CGSize _contentSize;
    NSMutableArray<UICollectionViewLayoutAttributes *> *_totalLayoutAttributes;
    
}

/*
 * 获得某个indexPath位于哪一列，哪一行
 */
-(BHRowColumn)rowColumnForIndexPath:(NSIndexPath *)indexPath;

@property (nonatomic,weak) IBOutlet id<BHMultiModeWaterFlowLayoutDelegate,UICollectionViewDelegateFlowLayout> delegate;

@property (nonatomic,strong) NSMutableArray<BHCollectionSectionLayoutInfo *> *layoutInfoForSections;

@end

NS_ASSUME_NONNULL_END

//
//  BHMultiModeWaterFlowLayout.m
//  BHMultiModeWaterFlowLayout
//
//  Created by bighiung on 2020/8/12.
//  Copyright © 2020 bighiung. All rights reserved.
//

#import "BHMultiModeWaterFlowLayout.h"
@interface BHMultiModeWaterFlowLayout(){
    NSMutableDictionary *_indexPathRowColumnInfoIndexDict;
    BHRowColumn *_rowColumnInfos;
    int _currentRowColumnInfosSize;
    int _currentRowColumnInfosLastIndex;
}
@end
@implementation BHMultiModeWaterFlowLayout

-(NSMutableArray *)layoutInfoForSections
{
    if (_layoutInfoForSections == nil) {
        _layoutInfoForSections = [NSMutableArray new];
    }
    return _layoutInfoForSections;
}

-(void)dealloc
{
    if (_rowColumnInfos) {
        
        free(_rowColumnInfos);
    }
}

-(void)prepareLayout
{
    [self.layoutInfoForSections removeAllObjects];
    //计算完整的布局信息
    _totalLayoutAttributes = [NSMutableArray new];
    
    if (_indexPathRowColumnInfoIndexDict == nil) {
        _indexPathRowColumnInfoIndexDict = [NSMutableDictionary new];
    }
    else
    {
        [_indexPathRowColumnInfoIndexDict removeAllObjects];
    }
    
    if (_rowColumnInfos == NULL) {
        _currentRowColumnInfosSize = 1024;
        _rowColumnInfos = (BHRowColumn *)calloc(_currentRowColumnInfosSize, sizeof(BHRowColumn));
    }
    _currentRowColumnInfosLastIndex = -1;
    
    NSInteger numOfSections = self.collectionView.numberOfSections;
    //每一个section计算 header Footer 等等的布局信息，以及该section的总高度
    UIEdgeInsets sectionInset = self.sectionInset;
    CGFloat collectionViewWidth = self.collectionView.frame.size.width;
    CGFloat left = sectionInset.left,right = sectionInset.right,top = sectionInset.top,bottom = sectionInset.bottom;
    _contentSize = CGSizeMake(collectionViewWidth,top);
    for (NSInteger sectionIndex = 0; sectionIndex != numOfSections; sectionIndex++) {
        CGFloat currentY = _contentSize.height + sectionInset.top;
        BHCollectionSectionLayoutInfo *layoutInfoForCurrentSection = [BHCollectionSectionLayoutInfo new];
            //获取header的布局信息
            if ([_delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForHeaderInSection:)]) {
                CGSize sizeForCurrentSectionHeader = [_delegate collectionView:self.collectionView layout:self referenceSizeForHeaderInSection:sectionIndex];
                if (!CGSizeEqualToSize(sizeForCurrentSectionHeader, CGSizeZero)) {
                    layoutInfoForCurrentSection.frameForHeader = CGRectMake(left, currentY, collectionViewWidth - left - right, sizeForCurrentSectionHeader.height);
                    currentY += sizeForCurrentSectionHeader.height;
                    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:[NSIndexPath indexPathForRow:0 inSection:sectionIndex]];
                    attributes.frame = layoutInfoForCurrentSection.frameForHeader;
                    [_totalLayoutAttributes addObject:attributes];
                }
            }
        //获取各个单元格的size信息
        currentY += [self addLayoutInfoForCells:layoutInfoForCurrentSection currentY:currentY section:sectionIndex];
        //获取 footer 相关布局信息
        if ([_delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForHeaderInSection:)]) {
            CGSize sizeForCurrentSectionFooter = [_delegate collectionView:self.collectionView layout:self referenceSizeForFooterInSection:sectionIndex];
            if (!CGSizeEqualToSize(sizeForCurrentSectionFooter, CGSizeZero)) {
                layoutInfoForCurrentSection.frameForFooter = CGRectMake(left, currentY, collectionViewWidth - left - right, sizeForCurrentSectionFooter.height);
                currentY += sizeForCurrentSectionFooter.height;
                UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:[NSIndexPath indexPathForRow:0 inSection:sectionIndex]];
                attributes.frame = layoutInfoForCurrentSection.frameForFooter;
                [_totalLayoutAttributes addObject:attributes];
            }
        }
        currentY += bottom;
        layoutInfoForCurrentSection.sizeForSection = CGSizeMake(collectionViewWidth, _contentSize.height - currentY);
        [self.layoutInfoForSections addObject:layoutInfoForCurrentSection];
        _contentSize.height = currentY;
    }
}

//返回值是所有单元格总共的高度
-(CGFloat)addLayoutInfoForCells:(BHCollectionSectionLayoutInfo *)layoutInfo currentY:(CGFloat)Y section:(NSInteger)sectionIndex
{
    
    NSInteger columnNumOfCurrentSection = 1;
    CGFloat collectionViewWidth = self.collectionView.frame.size.width;

    if ([_delegate respondsToSelector:@selector(collectionView:layout:numOfColumnInSection:)]) {
        columnNumOfCurrentSection = [_delegate collectionView:self.collectionView layout:self numOfColumnInSection:sectionIndex];
    }
    
    NSInteger numOfItemInCurrentSection = [self.collectionView numberOfItemsInSection:sectionIndex];
    CGFloat itemSpacing = self.minimumInteritemSpacing;
    CGFloat lineSpacing = self.minimumLineSpacing;
    
    
    if ([_delegate respondsToSelector:@selector(collectionView:layout:lineSpacingInSection:)]) {
        lineSpacing = [_delegate collectionView:self.collectionView layout:self lineSpacingInSection:sectionIndex];
    }
    
    if ([_delegate respondsToSelector:@selector(collectionView:layout:itemMinSpacingInSection:)]) {
        itemSpacing = [_delegate collectionView:self.collectionView layout:self itemMinSpacingInSection:sectionIndex];
    }
    UIEdgeInsets sectionInset = self.sectionInset;

    
    CGFloat left = sectionInset.left,right = sectionInset.right,top = sectionInset.top,bottom = sectionInset.bottom;
    
    Y += top;

    CGFloat standardWidthOfColumn = (collectionViewWidth - itemSpacing * columnNumOfCurrentSection + itemSpacing - left - right) / columnNumOfCurrentSection;
    
    //初始化各列的高度为0
    NSMutableArray *heightForColumn = [NSMutableArray arrayWithCapacity:columnNumOfCurrentSection];
    
    NSMutableArray *rowCountForColumn = [NSMutableArray arrayWithCapacity:columnNumOfCurrentSection];

    for (NSInteger columnIndex = 0; columnIndex != columnNumOfCurrentSection; columnIndex++) {
        [heightForColumn addObject:@(lineSpacing)];
        [rowCountForColumn addObject:@(0)];
    }
    
    
    for (NSInteger itemIndex = 0; itemIndex != numOfItemInCurrentSection; itemIndex++) {
                
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:itemIndex inSection:sectionIndex];

        CGSize sizeForCell = [_delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
        CGRect frameForCell;
        __block NSUInteger columnIndex = 0;
        if (sizeForCell.width > standardWidthOfColumn + itemSpacing) {
            //有一个超宽的单元格
            //直接占据放到最高的一行的高度后面
            __block CGFloat maxHeight = CGFLOAT_MIN;
            [heightForColumn enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                CGFloat currentHeight = [obj doubleValue];
                if (currentHeight > maxHeight) {
                    columnIndex = idx;
                    maxHeight = currentHeight;
                }
            }];
            //将单元格Frame设置在minIndex
            frameForCell = CGRectMake(left + (standardWidthOfColumn + itemSpacing) * columnIndex , maxHeight + Y,sizeForCell.width,sizeForCell.height);
            CGFloat currentTotalHeight = maxHeight + sizeForCell.height + lineSpacing;
            NSNumber *numOfTotalHeight = @(currentTotalHeight);
            for (NSInteger idx = 0; idx != columnNumOfCurrentSection; idx++) {
                heightForColumn[columnIndex] = numOfTotalHeight;
            }
        }
        else
        {
            //否则挑选一个高度最低的列，放到那个列当中
            __block CGFloat minHeight = CGFLOAT_MAX;
            [heightForColumn enumerateObjectsUsingBlock:^(NSNumber   * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                CGFloat currentHeight = [obj doubleValue];
                if (currentHeight < minHeight) {
                    columnIndex = idx;
                    minHeight = currentHeight;
                }
            }];
            //将单元格Frame设置在minIndex
            frameForCell = CGRectMake(left + (standardWidthOfColumn + itemSpacing) * columnIndex , minHeight + Y,sizeForCell.width,sizeForCell.height);
            heightForColumn[columnIndex] = @(minHeight + sizeForCell.height + lineSpacing);
        }
        //记录下当前indexPath 在哪一行 ，哪一列。
        BHRowColumn rowColumn;
        rowColumn.column = columnIndex;
        NSNumber *currentRowCount = rowCountForColumn[columnIndex];
        rowColumn.row = [currentRowCount integerValue];
        rowColumn.section = sectionIndex;
        rowCountForColumn[columnIndex] = @(rowColumn.row + 1);
        _currentRowColumnInfosLastIndex++;
        //容量不足时进行扩容
        if (_currentRowColumnInfosLastIndex == _currentRowColumnInfosSize) {
            BHRowColumn *newSpace = calloc(_currentRowColumnInfosSize * 2, sizeof(BHRowColumn));
            memcpy(newSpace, _rowColumnInfos, sizeof(BHRowColumn) * _currentRowColumnInfosSize);
            free(_rowColumnInfos);
            _rowColumnInfos = newSpace;
            _currentRowColumnInfosSize = _currentRowColumnInfosSize * 2;
        }
        _rowColumnInfos[_currentRowColumnInfosLastIndex] = rowColumn;
        _indexPathRowColumnInfoIndexDict[[NSString stringWithFormat:@"%ld,%ld",indexPath.row,indexPath.section]] = @(_currentRowColumnInfosLastIndex);
        //添加一个layout属性
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForRow:itemIndex inSection:sectionIndex]];
        attributes.frame = frameForCell;
        [layoutInfo.layoutAttributeForCells addObject:attributes];
        [_totalLayoutAttributes addObject:attributes];
    }
    
    __block CGFloat maxHeight = CGFLOAT_MIN;

    [heightForColumn enumerateObjectsUsingBlock:^(NSNumber   * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat currentHeight = [obj doubleValue];
        if (currentHeight > maxHeight) {
            maxHeight = currentHeight;
        }
    }];
    maxHeight += bottom;
    //返回当前Section全部cell占据的高度
    return maxHeight;
}

-(CGSize)collectionViewContentSize
{
    CGSize size = CGSizeMake(self.collectionView.frame.size.width, MAX(_contentSize.height + self.sectionInset.top + self.sectionInset.bottom, self.collectionView.frame.size.height));
    
    return size;
}

//为cell提供布局属性
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)Rect
{
    //过滤出处于rect当中的attributes
    return _totalLayoutAttributes;
}

-(BHRowColumn)rowColumnForIndexPath:(NSIndexPath *)indexPath{
    NSNumber *infoIndexNumber = _indexPathRowColumnInfoIndexDict[[NSString stringWithFormat:@"%ld,%ld",indexPath.row,indexPath.section]];
    if (infoIndexNumber) {
        return _rowColumnInfos[[infoIndexNumber integerValue]];
    }
    BHRowColumn rowColumn;
    rowColumn.column = 0;
    rowColumn.row = 0;
    rowColumn.section = 0;
    return rowColumn;
}


@end

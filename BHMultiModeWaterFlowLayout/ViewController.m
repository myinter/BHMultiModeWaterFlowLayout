//
//  ViewController.m
//  BHMultiModeWaterFlowLayout
//
//  Created by bighiung on 2020/8/12.
//  Copyright © 2020 bighiung. All rights reserved.
//

#import "ViewController.h"
#import "ListCell.h"
#import "WaterfallCell.h"

#import "HeaderView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [_collectionView registerNib:[UINib nibWithNibName:@"ListCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"ListCell"];

    [_collectionView registerNib:[UINib nibWithNibName:@"WaterfallCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"Waterfall"];
    
    UINib *nib = [UINib nibWithNibName:@"HeaderView" bundle:[NSBundle mainBundle]];
    [_collectionView registerNib:nib
      forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header"];
    
    nib = [UINib nibWithNibName:@"FooterView" bundle:[NSBundle mainBundle]];
    [_collectionView registerNib:nib forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"Footer"];

    _waterFlowLayout.minimumInteritemSpacing = 12.0;
    
    _waterFlowLayout.minimumLineSpacing = 0.0;
    
    _waterFlowLayout.sectionInset = UIEdgeInsetsMake(2.0, 12.0, 2.0, 12.0);
    
    _dataSource = [NSMutableArray arrayWithArray:@[
        @{
            @"list":@[@"1231",@"123",@"好东西",@"SDSD",@"SSS"]
        },
        @{
            @"list":@[@"1231",@"123",@"好东西",@"好东西",@"好东西",@"好东西"]
        }
    ]];

}

- (IBAction)insertASection:(UIButton *)sender {
    
    
    NSInteger sectionNum = _dataSource.count;
    
    [_dataSource addObject:@{
        @"list":@[@"1231",@"123",@"好东西",@"好东西",@"好东西",@"好东西"]
    }];
    
    [_collectionView reloadData];
//    [_collectionView reloadSections:[NSIndexSet indexSetWithIndex:sectionNum]];
    
}


- (IBAction)insert:(UIButton *)sender {
    
    static int kkk = 0;
    
    if (kkk % 2) {
        NSMutableArray *indecesTobeInserted = [NSMutableArray new];
        [indecesTobeInserted addObject:[NSIndexPath indexPathForRow:3 inSection:0]];
        [indecesTobeInserted addObject:[NSIndexPath indexPathForRow:4 inSection:0]];
        
        NSArray *array  = _dataSource[0][@"list"];
        
        NSMutableArray *newArray = [NSMutableArray arrayWithArray:array];
        [newArray insertObjects:@[@"不要啊",@"牛人"] atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, 2)]];
        [_collectionView performBatchUpdates:^{
            _dataSource[0] = @{@"list":newArray};
            [_collectionView insertItemsAtIndexPaths:indecesTobeInserted];
        } completion:^(BOOL finished) {
            [_collectionView reloadData];
        }];
    }
    else
    {
        NSMutableArray *indecesTobeInserted = [NSMutableArray new];
        [indecesTobeInserted addObject:[NSIndexPath indexPathForRow:3 inSection:1]];
        [indecesTobeInserted addObject:[NSIndexPath indexPathForRow:4 inSection:1]];
        
        NSArray *array  = _dataSource[1][@"list"];
        
        NSMutableArray *newArray = [NSMutableArray arrayWithArray:array];
        [newArray insertObjects:@[@"好东西",@"牛人"] atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(2, 2)]];
        [_collectionView performBatchUpdates:^{
            _dataSource[1] = @{@"list":newArray};
            [_collectionView insertItemsAtIndexPaths:indecesTobeInserted];
        } completion:^(BOOL finished) {
            [_collectionView reloadData];
        }];
    }
    
    kkk++;
}

- (NSInteger)collectionView:(UICollectionView *_Nonnull)collectionView layout:(UICollectionViewLayout*_Nonnull)collectionViewLayout numOfColumnInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 2;
            
        default:
            break;
    }
    return 1;
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _dataSource.count;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSDictionary *data = _dataSource[section];
    NSArray *array = data[@"list"];
    return array.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ListCell *cell;
    NSDictionary *data = _dataSource[indexPath.section];
    NSArray *array = data[@"list"];

    switch (indexPath.section) {
        case 0:
        {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ListCell" forIndexPath:indexPath];
            cell.backgroundColor = [UIColor greenColor];

        }
            break;
        case 1:
        {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Waterfall" forIndexPath:indexPath];
            cell.backgroundColor = [UIColor blueColor];
        }
            break;
        default:
        {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ListCell" forIndexPath:indexPath];
            cell.backgroundColor = [UIColor greenColor];

        }
            break;
    }
    cell.label.text = [NSString stringWithFormat:@"section %ld row %d %@",(long)indexPath.section,(long)indexPath.row,array[indexPath.row]];

    return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"indexPath row %d section %d",indexPath.row,indexPath.section);
    
    //获取哪一行 哪一列
    BHRowColumn rowColumn = [_waterFlowLayout rowColumnForIndexPath:indexPath];
    
    NSLog(@"rowColumn row %d column %d",rowColumn.row,rowColumn.column);
    
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //section 0 一排一
    
    //section 1 一排二
    switch (indexPath.section) {
        case 0:
        {
            return CGSizeMake(collectionView.frame.size.width, 100.0);
        }
            break;
        case 1:
        {
            return CGSizeMake( collectionView.frame.size.width * 0.4, 200.0 + indexPath.row * 40);
        }
            break;
        default:
            break;
    }
    
    return CGSizeMake(collectionView.frame.size.width, 100.0);
}


- (CGFloat)collectionView:(UICollectionView *_Nonnull)collectionView layout:(BHMultiModeWaterFlowLayout *_Nonnull)collectionViewLayout itemMinSpacingInSection:(NSInteger)section{
    switch (section) {
        case 0:
        {
            return 0.0;
        }
            break;
        case 1:
        {
            return 12.0;
        }
            break;
        default:
            break;
    }
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *_Nonnull)collectionView layout:(BHMultiModeWaterFlowLayout *_Nonnull)collectionViewLayout lineSpacingInSection:(NSInteger)section;
{
    switch (section) {
        case 0:
        {
            return 0.0;
        }
            break;
        case 1:
        {
            return 10.0;
        }
            break;
        default:
            break;
    }
    return 0.0;
}

- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    HeaderView *reuseView;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        reuseView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header" forIndexPath:indexPath];
        reuseView.label.text = [NSString stringWithFormat:@"Header section %ld",(long)indexPath.section];
    }
    else
    {
        reuseView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"Footer" forIndexPath:indexPath];
        reuseView.label.text = [NSString stringWithFormat:@"Footer section %ld",(long)indexPath.section];
    }
    return reuseView;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(_collectionView.frame.size.width, 44);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{

    return CGSizeMake(_collectionView.frame.size.width, 44);
}

@end

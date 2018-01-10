
#import "NewDownloadModule.h"
#import "DownloadNode.h"
#import "Download_level0_Model.h"
#import "Download_level1_Model.h"
#import "Download_level2_Model.h"

@implementation NewDownloadModule

static NewDownloadModule *_instance = nil;

+ (NewDownloadModule *)getInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance                       = [[NewDownloadModule alloc] init];
        _instance.dataArray             = [NSMutableArray array];
        _instance.allMapArray           = [NSMutableArray array];
        _instance.displayArray          = [NSMutableArray array];
        _instance.downloadedArray       = [NSMutableArray array];
        _instance.downloadingArray      = [NSMutableArray array];
        _instance.continentNameArr      = [NSMutableArray array];
        _instance.downloadFailArray     = [NSMutableArray array];
        _instance.tempDownloadedArray   = [NSMutableArray array];
        _instance.needToUpdateMap   = [NSMutableArray array];
        _instance.mapDic                = [NSMutableDictionary dictionaryWithCapacity:0];
        
        [_instance initData];
    });
    return _instance;
}

- (void)initData {
    [self parseJsonForPath];
    [self addDataArrayWithMapDic];
}

- (void)addDataArrayWithMapDic{
    if ([_dataArray count] > 0) {
        return;
    }
    [_continentNameArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *continentName_ = obj;
        NSMutableArray *node0Sons = [NSMutableArray arrayWithCapacity:0];
        DownloadNode *node0 = [[DownloadNode alloc]init];
        node0.nodeLevel = 0;
        node0.type = 0;
        node0.sonNodes = nil;
        node0.isExpanded = FALSE;
        Download_level0_Model *tmp0 = [[Download_level0_Model alloc]init];
        tmp0.continentName = continentName_;
        node0.nodeData = tmp0;
        NSArray *continentArr_ = [_mapDic objectForKey:continentName_];
        [continentArr_ enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSMutableArray *node1Sons = [NSMutableArray arrayWithCapacity:0];
            NSDictionary *countryDic_ = obj;
            DownloadNode *node1 = [[DownloadNode alloc]init];
            node1.nodeLevel = 1;
            node1.type = 1;
            node1.sonNodes = nil;
            node1.isExpanded = FALSE;
            Download_level1_Model *tmp1 =[[Download_level1_Model alloc]init];
            tmp1.countryName = [countryDic_ objectForKey:@"title"];
            tmp1.headImgPath = [countryDic_ objectForKey:@"icon"];
            tmp1.headImgUrl = nil;
            node1.nodeData = tmp1;
            [node0Sons addObject:node1];
            NSArray *mapArr = [countryDic_ objectForKey:@"map"];
            [mapArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                MapModel *model = obj;
                DownloadNode *node2 = [[DownloadNode alloc]init];
                node2.nodeLevel = 2;
                node2.type = 2;
                node2.sonNodes = nil;
                node2.isExpanded = FALSE;
                Download_level2_Model *tmp2 =[[Download_level2_Model alloc]init];
                tmp2.model = model;
                node2.nodeData = tmp2;
                [node1Sons addObject:node2];
            }];
            node1.sonNodes = node1Sons;
        }];
        node0.sonNodes = node0Sons;
        [_dataArray addObject:node0];
    }];
}

- (void)parseJsonForPath {
    if ([_mapDic count] > 0) {
        return;
    }
//    [self addBasicMap];
    NSString* path = @"";
//    NSString *curLanuage = [Bridge getUserLanguage];
//    if ([curLanuage isEqualToString:@"CN"]) {
        path = [[NSBundle mainBundle] pathForResource:@"maplist_cn" ofType:@"json"];
//    }
//    else if ([curLanuage isEqualToString:@"FR"]){
//        path = [BOOBUZ_MYBUNDLE pathForResource:@"maplist_fr" ofType:@"json"];
//    }
//    else{
//        path = [BOOBUZ_MYBUNDLE pathForResource:@"maplist" ofType:@"json"];
//    }
    
    NSError *error = nil;
    NSDictionary *allDic = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path] options:NSJSONReadingAllowFragments error:&error];
    NSDictionary *mapListDic = [allDic objectForKey:@"mapList"];
    NSArray *continentArr = [mapListDic objectForKey:@"continent"];
    
    [continentArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSMutableArray *continentArrTemp = [NSMutableArray arrayWithCapacity:0];
        NSDictionary *dic_ = obj;
        NSString *continentName = [dic_ objectForKey:@"-title"];
        NSArray *countryArr_ = [dic_ objectForKey:@"country"];
        
        [countryArr_ enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            NSDictionary *countryDic_ = obj;
            NSString *countryName = [countryDic_ objectForKey:@"-title"];
            NSString *countryId = [countryDic_ objectForKey:@"-id"];
            NSString *countryIcon = [NSString stringWithFormat:@"%@_%@", @"country",countryId];
            
            NSArray *mapArr_ = [countryDic_ objectForKey:@"map"];
            NSMutableArray *mapArrTemp = [NSMutableArray arrayWithCapacity:0];
            NSMutableDictionary *countryDicTemp = [NSMutableDictionary dictionaryWithCapacity:0];
            [mapArr_ enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSDictionary *mapDic_ = obj;
                if (![[mapDic_ objectForKey:@"-id"] isEqualToString:@"-1"]) {
                    
                    MapModel *model = [[MapModel alloc]init];
                    model.mapId = [mapDic_ objectForKey:@"-id"];
                    model.titleStr = [mapDic_ objectForKey:@"-title"];
                    model.cityDescriptionStr = [mapDic_ objectForKey:@"-citylist"];
                    //                model.packageNameStr = [mapDic_ objectForKey:@"packageName"];
                    model.tourMapSize = [mapDic_ objectForKey:@"-toursize"];
                    model.navMapSize = [mapDic_ objectForKey:@"-navsize"];
                    model.continentId = [mapDic_ objectForKey:@"-continent"];
                    
                    model.imageStr = countryIcon;
                    model.countryId = countryId;
                    model.continentName = continentName;
                    model.countryName = countryName;
                    model.curIndex = idx;
                    //                    DLog(@"%@%@", continentName, countryName);
                    [_allMapArray addObject:model];
                    [mapArrTemp addObject:model];
                }
            }];
            [countryDicTemp setObject:countryName forKey:@"title"];
            [countryDicTemp setObject:countryIcon forKey:@"icon"];
            [countryDicTemp setObject:mapArrTemp forKey:@"map"];
            [countryDicTemp setObject:countryId forKey:@"countryId"];
            [continentArrTemp addObject:countryDicTemp];
        }];
        [_mapDic setObject:continentArrTemp forKey:continentName];
        [_continentNameArr addObject:continentName];
    }];
}

@end

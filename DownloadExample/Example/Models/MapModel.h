
#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, downloadState) {
    downloadNone = 0,
    downloadPause,
    downloading,
    downloaded,
    downloadWait,
    downloadFailed,
    downloadUpziping,//地图解压中
    downloadUpziped,//地图解压完成
    downloadUpzipFailed//地图解压失败
};

typedef NS_ENUM(NSInteger, DownloadUpdateState) {
    updateStateNone = 0,
    updateStateDownload,//地图下载
    updateStateUpdate,//地图更新
    updateStateChange//地图切换下载
};//当时是地图下载、地图更新下载、地图切换下载

typedef NS_ENUM(NSInteger, MapStype) {
    mapStypeNone = 0,
    mapStypeTour,//旅游包
    mapStypeNav,//导航包
};//当前下载的是旅游包还是导航包


@interface MapModel : NSObject <NSCoding, NSMutableCopying, NSCopying>

//图片名称（为0表示为目录项）
@property (nonatomic, strong) NSString *imageStr;

//地图城市名称
@property (nonatomic, strong) NSString *titleStr;

//城市详细描述描述
@property (nonatomic, strong) NSString *cityDescriptionStr;

//解压文件夹名称
@property (nonatomic, strong) NSString *packageNameStr;

@property (nonatomic, strong) NSNumber *tourMapSize;//旅游包大小
@property (nonatomic, strong) NSNumber *navMapSize;//导航包大小
@property (nonatomic, assign)DownloadUpdateState downloadUpdateState;
@property (nonatomic, assign)MapStype mapStype;
//地图ID
@property (nonatomic, strong) NSString * mapId;

@property (nonatomic, copy) NSString *countryId;
//进度条的大小
@property (nonatomic, strong)NSNumber *progressValue;
//是否正在下载
@property (nonatomic, assign) BOOL isDownload;
//是否是暂停状态
@property (nonatomic, assign) BOOL isPause;

//当前所在的cell的组
@property (nonatomic, strong) NSNumber *section;
//当前所在的cell的行
@property (nonatomic, strong) NSNumber *row;
//已经下载的地图的路径
@property (nonatomic, strong) NSString *filePath;

@property (nonatomic, assign)downloadState state;
//@property (nonatomic, assign)mapUpdateState updateState;

@property (nonatomic, strong)NSString *continentName; //所属洲名
@property (nonatomic, strong)NSString *continentId; //所属洲ID
@property (nonatomic, strong)NSString *countryName; //所属国家名
@property (nonatomic, assign)NSInteger curIndex; //所在国家的位置
@end


#import "MapModel.h"

@implementation MapModel

- (instancetype)init{
    self = [super init];
    if (self) {
        _progressValue = @0.0;
        _isDownload = NO;
        _isPause = NO;
        _state = downloadNone;
        _cityDescriptionStr = @"";
        _packageNameStr = @"";
        _titleStr = @"";
        _imageStr = @"";
        _continentName = @"";
        _countryName = @"";
        _navMapSize = @0;
        _tourMapSize = @0;
        _downloadUpdateState = updateStateDownload;
        _mapStype = mapStypeNone;
        _continentId = @"";
        _section = @0;
        _row = @0;
    }
    return self;
}


#pragma mark - NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.imageStr forKey:NSStringFromSelector(@selector(imageStr))];
    [aCoder encodeObject:self.titleStr forKey:NSStringFromSelector(@selector(titleStr))];
    [aCoder encodeObject:self.cityDescriptionStr forKey:NSStringFromSelector(@selector(cityDescriptionStr))];
    [aCoder encodeObject:self.packageNameStr forKey:NSStringFromSelector(@selector(packageNameStr))];
    [aCoder encodeObject:self.tourMapSize forKey:NSStringFromSelector(@selector(tourMapSize))];
    [aCoder encodeObject:self.navMapSize forKey:NSStringFromSelector(@selector(navMapSize))];
    [aCoder encodeInteger:self.downloadUpdateState forKey:NSStringFromSelector(@selector(downloadUpdateState))];
    [aCoder encodeInteger:self.mapStype forKey:NSStringFromSelector(@selector(mapStype))];
    [aCoder encodeObject:self.mapId forKey:NSStringFromSelector(@selector(mapId))];
    [aCoder encodeObject:self.countryId forKey:NSStringFromSelector(@selector(countryId))];
    [aCoder encodeObject:self.progressValue forKey:NSStringFromSelector(@selector(progressValue))];
    [aCoder encodeBool:self.isDownload forKey:NSStringFromSelector(@selector(isDownload))];
    [aCoder encodeBool:self.isPause forKey:NSStringFromSelector(@selector(isPause))];
    [aCoder encodeObject:self.section forKey:NSStringFromSelector(@selector(section))];
    [aCoder encodeObject:self.row forKey:NSStringFromSelector(@selector(row))];
    [aCoder encodeObject:self.filePath forKey:NSStringFromSelector(@selector(filePath))];
    [aCoder encodeInteger:self.state forKey:NSStringFromSelector(@selector(state))];
    [aCoder encodeObject:self.continentName forKey:NSStringFromSelector(@selector(continentName))];
    [aCoder encodeObject:self.continentId forKey:NSStringFromSelector(@selector(continentId))];
    [aCoder encodeObject:self.countryName forKey:NSStringFromSelector(@selector(countryName))];
    [aCoder encodeInteger:self.curIndex forKey:NSStringFromSelector(@selector(curIndex))];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _imageStr = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(imageStr))];
        self.titleStr = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(titleStr))];
        self.cityDescriptionStr = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(cityDescriptionStr))];
        self.packageNameStr = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(packageNameStr))];
        self.tourMapSize = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(tourMapSize))];
        self.navMapSize = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(navMapSize))];
        self.downloadUpdateState = (DownloadUpdateState)[aDecoder decodeIntegerForKey:NSStringFromSelector(@selector(downloadUpdateState))];
        self.mapStype = [aDecoder decodeIntegerForKey:NSStringFromSelector(@selector(mapStype))];
        self.mapId = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(mapId))];
        self.countryId = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(countryId))];
        self.progressValue = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(progressValue))];
        self.isDownload = [aDecoder decodeBoolForKey:NSStringFromSelector(@selector(isDownload))];
        self.isPause = [aDecoder decodeBoolForKey:NSStringFromSelector(@selector(isPause))];
        self.section = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(section))];
        self.row = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(row))];
        self.filePath = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(filePath))];
        self.state = [aDecoder decodeIntegerForKey:NSStringFromSelector(@selector(state))];
        self.continentName = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(continentName))];
        self.continentId = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(continentId))];
        self.countryName = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(countryName))];
        self.curIndex = [aDecoder decodeIntegerForKey:NSStringFromSelector(@selector(curIndex))];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    MapModel *map = [[MapModel allocWithZone:zone] init];
    map.imageStr = _imageStr;
    map.titleStr = self.titleStr;
    map.cityDescriptionStr = self.cityDescriptionStr;
    map.packageNameStr = self.packageNameStr;
    map.tourMapSize = self.tourMapSize;
    map.navMapSize =  self.navMapSize;
    map.downloadUpdateState = self.downloadUpdateState;
    map.mapId = self.mapId;
    map.countryId = self.countryId;
    map.progressValue = self.progressValue;
    map.isDownload = self.isDownload;
    map.isPause = self.isPause;
    map.section = self.section;
    map.row = self.row;
    map.filePath = self.filePath;
    map.state = self.state;
    map.continentName = self.continentName;
    map.continentId = self.continentId;
    map.continentName = self.countryName;
    map.curIndex = self.curIndex;
    return map;
}

@end

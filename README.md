# VLCPlayerDemo

VLC Media Player (VideoLAN) 为 Windows、Linux、OS X、Android、iOS、Windows Phone等平台提供一个视频播放器、解码器。它可以播放来自网络、摄像头、磁盘、光驱的文件，支持包括MPEG 1/2/4, H264, VC-1, DivX, WMV, Vorbis, AC3, AAC等格式的解码。在 Windows 和 Linux 上的 VLC 是使用C++/Qt写成，提供了一致的用户体验。同时 VLC 还专门为 OS X 提供了原生版本，OS X 版的 VLC 的用户界面使用Cocoa框架编写，在 OS X 下拥有卓越的原生体验。

VLC集成
======

在iOS下，我们可以很方便的使用VLC，因为它经行了优秀的封装，源码中最核心的部分被封装成了独立的库（MoblieVLVKit.framework库），它是基于FFmpeg，Live555提供完整的媒体播放库，所以整一个库体积还是比较大（目前已经超过600M了），不过并不会太影响App的大小，经行App打包发布的是会自动超级压缩的。经过测试它比使用FFmpeg库仅仅是多7M左右的大小。

VLC cocoapods方式集成
------------
1.在podfile中写入：pod 'MobileVLCKit'

2.终端执行pod install即可（成功后会在项目里看到MoblieVLCKit.framework库）

3.添加依赖库：libz.tbd、libbz2.tbd、libiconv.tbd、libstdc++.6.0.9.tbd

直接引用
------------
下载MoblieVLCKit.framework直接链接进行编译

注意：由于MoblieVLCKit.framework不支持bitcode，在工程中需要关闭bitcode，即在TARGETS->Bulid Settings->Build Options->Enable Bitcode设置为NO。

VLC使用
======
VLCMediaPlayer
------------
VCL对象，管理着播放的开始暂停等操作，有着几个代理方法可以经行状态和时间的监听回调
VLCMediaPlayer属性
------------
```objc
// 播放设置，比如设置播放路径是本地播放还是网络播放，以及播放的画面映射到哪个View
@property (NS_NONATOMIC_IOSONLY, strong) VLCMedia *media;
```
VLCMediaPlayer方法
------------
```objc
// 开始播放
-(BOOL)play;
// 暂停播放
- (void)pause;
// 停止播放
- (void)stop;
/**
  *快进播放
  *interval:需要快进的秒数
*/
- (void)jumpForward:(int)interval;
/**
  *快退播放
  *interval:需要快退的秒数
*/
- (void)jumpBackward:(int)interval;
// 短时间的快退（10秒）
- (void)shortJumpBackward;
// 短时间的快进（10秒）
- (void)shortJumpForward;
/**
  * 以一定倍速播放
  * rate：倍速
*/
- (void)fastForwardAtRate:(float)rate;
```
VLCMediaPlayer代理
------------
```objc
// 播放状态改变的回调
- (void)mediaPlayerStateChanged:(NSNotification *)aNotification;
// 播放时间改变的回调
- (void)mediaPlayerTimeChanged:(NSNotification *)aNotification;
```
获取视频截图
```objc
//使用 AVAssetImageGenerator 获取缩略图
-(UIImage *)thumbnailImageRequest:(CGFloat )timeBySecond{
    //根据url创建AVURLAsset
    AVURLAsset *urlAsset = [AVURLAsset assetWithURL:m_playURL];
    //根据AVURLAsset创建AVAssetImageGenerator
    AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
    
    /*截图
     * requestTime:缩略图创建时间
     * actualTime:缩略图实际生成的时间
     */
    NSError *error=nil;
    //CMTime是表示电影时间信息的结构体，第一个参数表示是视频第几秒，第二个参数表示每秒帧数.(如果要活的某一秒的第几帧可以使用CMTimeMake方法)
    CMTime time = CMTimeMakeWithSeconds(timeBySecond, 10);
    
    CMTime actualTime;
    CGImageRef cgImage = [imageGenerator copyCGImageAtTime:time actualTime:&actualTime error:&error];
    
    if (error) {
        NSLog(@"截取视频缩略图时发生错误，错误信息：%@",error.localizedDescription);
        return nil;
    }
    
    CMTimeShow(actualTime);
    //转化为UIImage
    return  [UIImage imageWithCGImage:cgImage];
}
```
示例Demo工程
======
Demo下载地址:[https://github.com/sjjvenu/VLCPlayerDemo]((https://github.com/onevcat/vno-jekyll))
其中VLCPlayer为播放器类，VLCPlayerView为播放器View容器，VLCViewController为支持presentViewController方式弹出的controller，SCVideoMainViewController为支持pushViewController方式弹出的controller。

Demo中无需支持横屏模式即可横屏全屏播放，利用将视图旋转90度达到效果，具体实现考如下代码：
```objc
self.vlcPlayerView.rotateBlock = ^(NSInteger result){
        if (result == 0) { // 横屏
            // 旋转view
            weakSelf.view.transform = CGAffineTransformMakeRotation(M_PI/2); // 旋转90°
            CGRect frame = [UIScreen mainScreen].bounds; // 获取当前屏幕大小
            // 重新设置所有view的frame
            weakSelf.view.bounds = CGRectMake(0, 0,frame.size.height + 20,frame.size.width);
            weakSelf.vlcPlayerView.frame = weakSelf.view.bounds;
            weakSelf.bPortrait = NO;
            
            [weakSelf setNeedsStatusBarAppearanceUpdate];
        } else { // 竖屏
            // 旋转view
            weakSelf.view.transform = CGAffineTransformMakeRotation(M_PI*2); // 旋转90°
            CGRect frame = [UIScreen mainScreen].bounds; // 获取当前屏幕大小
            // 重新设置所有view的frame
            weakSelf.view.bounds = CGRectMake(0, 0,frame.size.width,frame.size.height);
            weakSelf.vlcPlayerView.frame = CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, playViewHeight);
            
            weakSelf.bPortrait = YES;
            [weakSelf setNeedsStatusBarAppearanceUpdate];
        }
    };
```
其他实现可参考Demo工程中详细代码。
注:Demo由于MoblieVLCKit.framework过大暂不上传，请自选下载替换。

本文参考[http://www.jianshu.com/p/178627b085c3](http://www.jianshu.com/p/178627b085c3)

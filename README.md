# LEUIMaker
LEUIFramework与LEUIFrameworkExtra的融合与升级，使用更简单、功能更强大。不喜欢使用约束，Masonry也觉得复杂，那么LEUIMaker可以成为替代方案。LEUIMakerUI开发神器的宗旨是简洁、轻便、智能，虽不能实现约束的所有功能，但是98%的UI开发模块，LEUIMaker已完全能够满足。 

[![Version](https://img.shields.io/cocoapods/v/LEUIMaker.svg?style=flat)](http://cocoapods.org/pods/LEUIMaker)[![License](https://img.shields.io/cocoapods/l/LEUIMaker.svg?style=flat)](http://cocoapods.org/pods/LEUIMaker) 

##说明
###### 具体使用请打开Example运行测试，每个模块都写了对应的测试类，方便查看基本使用方法。
#### 项目依赖
* FMDB
* AFNetworking

#### 项目结构
* LEUICommon UI常量及基本设定（下方Foundation的补充）
  * 定义颜色常量：常用颜色、文字颜色组、背景颜色组、分割线颜色组、遮盖颜色组
  * 定义大小及间距：系列组件间距、系列行间距、系列头像大小
  * 定义字号系列及对应缩写
  * 定义设备机型获取
  * 定义列表：列表高度组、列表Section高度组
  * 导航栏自定义设定：标题字体、按钮字体、返回图片、背景色、标题颜色
  * 其他
* BottomTabbar 底部标签栏 
  * 自定义：图标数组、高亮图标数组、标题数组、对应关联页面数组、正常文字颜色、高亮文字颜色、父view
  * 点击触发回调：返回index下标，是否允许跳转到index所属界面
* Foundation 基础设定
  * 常量定义：状态栏高度、导航栏高度、Tabbar高度、屏幕宽高获取、分割线高度等
  * 获取字符串对应的二维码图片、获取指定颜色图片、其他便捷设定
* Hud 文字提示：text、enterTime（进入时间）、pauseTime（停留时间）、offset（偏移量），是否结束销毁
* ImageFrameworks 图片工具库
  * LEImageCropper 图片裁剪：image（原图）、aspect（宽高比）、radius（圆角）、回调
  * LEImageFrameworks UIImageView的扩展（可自定义支持的第三方如SDwebImage库来管理图片的下载及缓存）：设置占位图、根据url下载指定大小图片  
  * LEImagePicker 图片选择器：title（标题）、camera（来源允许相机）、ablum（来源允许相册）、remain（剩余可选图片数量）、max（总选择数量）、assets（已选择资源列表），VC（跳转vc），delegate（回调：回调已选图片assets、回调拍照、回调提示信息）
  * LEImagePreview 图片预览器（支持）：superview（父view）、data（图片数据源）、deleteCurrent（删除当前选中图片），delegate（回调滚动到或点击了某张图片）
* Layout 布局框架

* LEBanner 轮播器：
  * 初始化：父View、自定义Banner类名（可选）、方向、页面指示器位置及其偏移量
  * 调用：停留时间、数据源、滚动操作，停止操作、回调（已点击banner、index、data）
* LEConfigurableList 可配置列表管理器（本身是TB，通过数据源来指定Cell的模板、展示内容及点击事件。目的是快速选定模板即可与数据源对接）
  * 版本：LEConfigurableList（无下拉刷新）、LEConfigurableListWithRefresh（有下拉刷新）
  * 现支持8个常用模板、另外可以自定义模板（可以完美兼容）
* LEDate 日期的扩展
* LENetwork 数据请求模块
  * LEDataManager 数据存储（可自定义支持的第三方如FMDB库，目前已对FMDB做了支持）
  * LEResumeBrokenDownload 支持断点续传
  * LERequest AFNetworking的扩展，支持RESTFUL框架
    * 全局设定：是否打印请求、是否打印返回、是否打印返回的Json格式化内容、host、contentType、statusCode、服务器验证请求的key、服务端验证请求key对应值、MD5加密、从缓存拉取数据、服务器验证失败回调、全局提示信息
    * 请求构成：host、api、uri、head（字典）、type（get、post、head、patch、delete）、parameter（字典）、duration（缓存时长）、storeToDisk（存储请求结果到本地）、addition（请求附加内容）
    * 请求接口：leRequest、leRequestFromMemory、leRequestFromDiskIfExist、leCancleRequest
 
* ListView 列表 
  * LERefresh 上拉下拉组件，可扩展。initWithTarget（Scrollview）、initRefreshView（用户自定义刷新元素）、onBeginRefresh、onEndRefresh、onScrolling（滚动中，用户获取滚动进度） 
  * LECollectionView 网格状列表 
  * LETableView 单列列表
* Popup 弹出窗（局部自定义）
  * 询问弹窗
  * 信息确认弹窗  
* QRCode 二维码
  * 二维码扫描页面：标题、延时扫码、自定义页面提示语、自定义扫码结果页面及显示状态
  * 二维码展示页面  
* Segment 分段器
  * 初始化：superview、titles标题、pages对应页面
  * 是否等宽、文字正常色、文字高亮色、文字间距、指示器图片及偏移量、高度
  * 回调选择页面index
* VC ViewController封装
  * VC 在viewDidLoad时会自己搜索是否存在VC+"Page"的类（继承LEView），若存在则自动创建该对象并赋值给View对象
  * LEView 顶层View：容器及其宽和高、附容器及其高度、右划手势及其引用和开关
  * LENavigation 导航栏： 
    * 初始化：superview、title、回调（左侧按钮点击、右侧按钮点击、中间区域宽度变动）
    * 接口：导航栏标题设定、底部分割线、背景图、左侧按钮图片及颜色、右侧按钮图片及颜色、偏移量

## Installation

```ruby
use_frameworks!
target 'xxx' do
pod 'LEUIMaker'  
end
```

## Author

LarryEmerson, larryemerson@163.com

## License

LEUIMaker is available under the MIT license. See the LICENSE file for more info.



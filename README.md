# DoubanMovies
A demo that imitates the DoubanMovie app.

![DoubanMovie](https://raw.githubusercontent.com/StoneN/DoubanMovies/master/PicturesForREADME/DoubanMovie.gif)

### 功能：

- 分别用 UITableView 和 UICollectionView 展示不同豆瓣 API 返回的电影资源，资源展示支持 下拉刷新 和 上拉加载更多。
- 支持通过任意关键字搜索电影，搜索记录本地化存储。
- 选中一部电影可展示其简介。
- 支持通过 WebView 登陆豆瓣账户。

### 技术：

- 使用 CocoaPods 统一管理框架。
- 使用 AFNetworking 进行网络请求，使用 SDWebImage 异步加载网络图片，使用 MJRefresh 实现 UITableView 和 UICollectionView 的 下拉刷新 及 上拉加载更多。
- 使用 XML属性列表(plist)归档 存储搜索历史记录。

##### 缺陷：

> 1. 排行榜
>     - 单独多次加载同一榜单数据后切换榜单，程序以“数组访问越界”的原因崩溃
>     - 在不同榜单之间切换时，滚动条位置滞留
>     - 点击单个cell跳转【待完成】
> 2. 我的主页
>     - OAuth处理登陆，并获取用户信息进行展示【待完成】


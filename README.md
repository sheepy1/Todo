# Todo
## 项目介绍
Todo 是一个 iOS 平台的备忘录应用，事项按更新时间排序，支持远程数据更新和本地数据缓存。断网状态时可以正常浏览，但不能执行新增事项、编辑内容等操作，会有错误提示。如果本地数据与远程数据不同步，会提示用户通过下拉刷新进行同步（重新加载远程数据并缓存）。

### 部分效果展示

![新建事项](https://github.com/sheepy1/Todo/raw/master/Pic/create_item.gif)&nbsp;![修改事项](https://github.com/sheepy1/Todo/raw/master/Pic/update_item.gif)&nbsp;

![完成事项](https://github.com/sheepy1/Todo/raw/master/Pic/finish_item.gif)&nbsp;![撤销完成](https://github.com/sheepy1/Todo/raw/master/Pic/revert_item.gif)&nbsp;

![删除事项](https://github.com/sheepy1/Todo/raw/master/Pic/delete_item.gif)&nbsp;![筛选事项](https://github.com/sheepy1/Todo/raw/master/Pic/select_item_status.gif)&nbsp;

![离线操作](https://github.com/sheepy1/Todo/raw/master/Pic/local_finish.gif)&nbsp;

### 项目结构
![项目结构](https://github.com/sheepy1/Todo/raw/master/Pic/project_struct.png)

## 准备
* 开发工具：Xcode 7.2
* 运行平台：iOS 8.0+
* 双击 Todo.xcworkspace 打开

## 相关技术
* 语言：Swift 2.1
* 依赖管理工具：CocoaPods
* 网络任务：NSURLSession
* JSON 解析：第三方库 SwiftyJSON
* 本地缓存：第三方库 RealmSwift
* UI布局：Storyboard ＋ AutoLayout

## 项目亮点
* 界面简洁，操作简单，支持离线浏览，提示详尽，体验友好。
* 使用 Manager 类负责数据的增删改查，ViewModel 负责数据绑定， 这样 Controller 只需要负责响应用户操作，分工明确，逻辑清晰。
* 用字符串常量代替直接使用字符串，降低错误率。
* 实践面向协议编程的思想，代码具有较好的可扩展性。

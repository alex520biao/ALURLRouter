# ALURLRouter

强大而灵活的iOS组件化实施方案,模块间解耦URL工具.
ALURLRouter的目的是讲服务URL化，合理的服务包括但不仅限于ViewController页面。


ALURLRouter应该默认URL处理过程都是异步的,比如OpenURL接收方的处理过程是不可预知的不能假定为同步过程，因此只能认为是异步过程。
ALURLRouter中所有处理URL的方法callInsideURL、handleOpenURL等都认为是异步的。

1. 可以同时满足OpenURL与InsideURL的处理需求
2. ALInsideURL可以得到任务处理进度，处理结果:成功/失败,成功信息/失败NSError
3. ALInsideURL有返回值
4. ALInsideURL参数更灵活,不仅限于url的query字符。而且可以是系统通用的类型如UIImage、NSDate等。
5. 可以针对ALInsideURL和ALOpenURL实现灵活的权限控制

## 维护者

alex520biao <alex520biao@163.com>

## License

ALURLRouter is available under the MIT license. See the LICENSE file for more info.

###本项目来源参考学习以下项目:
* [https://github.com/joeldev/JLRoutes](https://github.com/joeldev/JLRoutes)
* [https://github.com/Huohua/HHRouter](https://github.com/Huohua/HHRouter)
* [https://segmentfault.com/a/1190000002585537](https://segmentfault.com/a/1190000002585537)
* [HHRouter 开源后日谈](http://www.jianshu.com/p/7ca99b592cce)
* [https://github.com/mogujie/MGJRouter?from=codefrom.com](https://github.com/mogujie/MGJRouter?from=codefrom.com)
* [蘑菇街App的组件化之路](https://mp.weixin.qq.com/s?__biz=MzA3ODg4MDk0Ng==&mid=402696366&idx=1&sn=ba8cbd75849b9657175c4b25bb0ac5b5&scene=1&srcid=0318ctwtgPxhr8gzk98C4y6B&key=710a5d99946419d95fc1a823e6be44fa85d087f247f9937989bbc67d044f1df603088be241db5bf4d35253b3cf670037)

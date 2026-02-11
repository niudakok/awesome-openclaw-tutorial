大家好，我是袋鼠帝。

最近这两周，我的X（推特）和各种群都被刷屏了。

如果说去年春节期间大家还在讨论 DeepSeek  ，那今年春节前，所有极客和效率狂人的目光都集中在了一个开源项目上。

它最早叫Clawdbot，后来改名叫Moltbot，最终正式定名为 OpenClaw  。

这玩意儿有多火？

短短20多天，GitHub 上的 Star 数像坐了火箭一样， <span style="color: rgb(36,91,219); background-color: inherit">从几百飙升到了 175 K </span>。而且还在猛涨。

![](https://my.feishu.cn/space/api/box/stream/download/asynccode/?code=ZTg1NmJhNzFkZDgwMzBlMmM2MWUxZDVhZTljYWVhYTZfMWZjaFRKZmlNZm5wVmJsVmp6azlRRGNBUU9PVnNCaW1fVG9rZW46RG9tZGJDVVQ2b2VNZEF4MG9kc2N5OFY1bnhoXzE3NzA3ODA3NTA6MTc3MDc4NDM1MF9WNA)

而Dify做到超100K Star大概花了3年，n8n则更久，大约花了6年

我甚至看到有朋友开玩笑说，以前买 Mac Mini 是为了做生产力工具，现在买 Mac Mini 是为了给 OpenClaw 找个家🤣。

![](https://my.feishu.cn/space/api/box/stream/download/asynccode/?code=MzdiOGNmODBjYWM4MDA5MjcyMTljMDQ2YzIyNTZmOWZfM3ZsT1ZhZWZnelQ0SlpreWVLMTVlN3JoVnJLMWhoZmdfVG9rZW46Rm10emJ2bFdnb0RDVm14TkpEVmNDUGo4bmxlXzE3NzA3ODA3NTA6MTc3MDc4NDM1MF9WNA)

作为一名一直在折腾 AI Agent 的博主，我当然坐不住。

这几天 <span style="color: rgb(36,91,219); background-color: inherit">我抽空疯狂研究OpenClaw，又是买服务器，又是配环境，把OpenClaw的多种玩法撸了一遍。</span>

体验下来，我感觉AI的下一形态，真的要来了。

<span style="color: rgb(36,91,219); background-color: inherit">今天这篇文章，我就把这几天的实操经验，揉碎了、掰开了，跟大家好好聊聊这个 OpenClaw 到底怎么用，以及它能给我们的生活和工作带来什么改变。</span>

主要内容有：

![](https://my.feishu.cn/space/api/box/stream/download/asynccode/?code=OGM2Y2QyOGEzOTM1ZGJlMjA2NDAxNzhiMjg1MTQ2MTFfbkxVdVlrc2t2VlJhUDBFYjVDY21BM2FkckY3dktOR3lfVG9rZW46TDNqcGIwTXJqb0E2R3N4Z2ZPdmNSbkgyblJkXzE3NzA3ODA3NTA6MTc3MDc4NDM1MF9WNA)



![](https://my.feishu.cn/space/api/box/stream/download/asynccode/?code=YmEyNzM0N2QzMmZkOGE2NTVhNTAxZTdkZmFkMGFiNDBfTkJmckN5eUh5Sk82M1lUUlprWFRGZ0hDQU1KTHRnSEJfVG9rZW46VnJMWmJkQlBVb2NvQTB4d2prMWNjdHZLbjVnXzE3NzA3ODA3NTA6MTc3MDc4NDM1MF9WNA)

<span style="color: inherit; background-color: rgb(242,243,245)">1.免费白嫖云服务器，且全程界面化操作配置openclaw； </span>

<span style="color: inherit; background-color: rgb(242,243,245)">2.怎么自定义接入任意模型API；</span>

<span style="color: inherit; background-color: rgb(242,243,245)">3.OpenClaw的4种实用玩法；</span>

<span style="color: inherit; background-color: rgb(242,243,245)">4.新手入坑建议。</span>

![](https://my.feishu.cn/space/api/box/stream/download/asynccode/?code=OGQyYjUzY2JjODQ0NzMwY2QwNTdjMTAxM2YzN2FlYmFfQ2hsb0ZmSUZ6UmlFUGxMbmVzQjhyaXlvc2gzcGNISUZfVG9rZW46UTVMR2JoYVB3bzNmamd4RjJkZmNrcDRwblFiXzE3NzA3ODA3NTA6MTc3MDc4NDM1MF9WNA)

**<span style="color: rgb(36,91,219); background-color: inherit">一、安装你的7✖️24小时AI助手（白嫖） </span>**

本质上只需要一台长期开机的电脑（你自己的本地电脑也行）

不过还是推荐上云服务器，只要服务器不宕机，你的AI助手就一直在。

很多人一听到部署、服务器、命令行，头就大了。

其实大厂跟进非常快，现在使用OpenClaw的门槛比你想象的要低很多了（可以界面化操作）。

之前有朋友就在问， <span style="color: rgb(36,91,219); background-color: inherit">有木有免费的云服务器可以白嫖的。</span>

emmm，之前没有，不过最近各家云厂商卷起来了，就有了 哈哈哈

上周去百度智能云Agent大会，发现 百度千帆  最近更新了一波好东西，其中针对openclaw的升级就非常吸引我

![](https://my.feishu.cn/space/api/box/stream/download/asynccode/?code=NTIzZmY0YzQ5OWVhOGY1ZTU1ODY1ZGJkZWY1Nzk5NDRfb2lmZHpnRzNQUWlKYTFZeHFSYW5mWHg5eHR6NmFNamdfVG9rZW46WE9xTmJoc2ZIb0M5Wk54WllVaGNCaURnbjJmXzE3NzA3ODA3NTA6MTc3MDc4NDM1MF9WNA)

<span style="color: rgb(36,91,219); background-color: inherit">首先是openclaw的一键部署，而且2H4G的服务器居然只要0.01¥/月？？</span>

*<span style="color: rgb(143,149,158); background-color: inherit">PS：2H4G这个配置，一般价格至少都是上百/月的 </span>*

https://cloud.baidu.com/product/BCC/moltbot.html

![](https://my.feishu.cn/space/api/box/stream/download/asynccode/?code=YmRmNGMyOGU3MzhhYWFjZDhmYWE3NTE2MTVhODZhMTVfVzBwUDBPMlBpNjhtSWJUeVMyU1NIM1ZHYzdaRUF2TFlfVG9rZW46QWFlZWJ3RlFwb25TZkF4VE5YNWNMT0tIbkxmXzE3NzA3ODA3NTA6MTc3MDc4NDM1MF9WNA)

注意，如果有 链接国外服务的需求， 地域可选 <span style="color: rgb(36,91,219); background-color: inherit">「香港」</span>

![](https://my.feishu.cn/space/api/box/stream/download/asynccode/?code=OGFhNTQyYjY3ZTU1NmY2N2I0YTliNDJmNWYyOGI1ODVfT0xFNlFSODFSYk1iZEtNOTlIbXdQQ0ExQ1A0MkNHajhfVG9rZW46Q3Axb2JOWjdib2hIbXh4U3p1cWNobXBqbndlXzE3NzA3ODA3NTA6MTc3MDc4NDM1MF9WNA)

开通成功后，去 <span style="color: rgb(36,91,219); background-color: inherit">管理控制台</span>

![](https://my.feishu.cn/space/api/box/stream/download/asynccode/?code=NDY3ZTdmYmQ3NjA3YmI4YzRlMDllNzEyYjljODYyZjlfOHZDeThpV0NrNWpBWUN0UkI0UFVadkNBS0c3MTBjUWNfVG9rZW46Qzc3VGJKaWpDb3pGanJ4U2JBeWNaVlNibmZmXzE3NzA3ODA3NTA6MTc3MDc4NDM1MF9WNA)

选择对应的地域，如果刚刚选的香港，这里就选择香港地区

找到刚刚创建的服务器实例，可以「远程登录」，输入刚刚设置的密码，进行ssh连接，通过命令行配置、启动openclaw

![](https://my.feishu.cn/space/api/box/stream/download/asynccode/?code=YTcxYWRjMGRhNGEyM2EzOTA4ZGUzNDkxOGY4M2FmYWJfZHcxczc4bkNyNTE0bGVRaEhYU0J6U0FhbnBJbE9HdW9fVG9rZW46TFJJOWI4ZGhib3ZTNVF4R3ZPSGNMZXNNblFkXzE3NzA3ODA3NTA6MTc3MDc4NDM1MF9WNA)

如果是小白，推荐点进 <span style="color: rgb(36,91,219); background-color: inherit">服务器详情页，应用管理-&gt;模型配置</span>

需要先 <span style="color: rgb(36,91,219); background-color: inherit">「一键开通」 </span>千帆大模型、云助手、运维编排OOS服务

![](https://my.feishu.cn/space/api/box/stream/download/asynccode/?code=NDI0YzkzYzJhYzdkYTQ3NmQ4ZDUyMzM3ZDliNjdmYmZfc21qb2g3QXFYU0RENzZFZGIxQ2UwbFV5cDZ5YTRXd0RfVG9rZW46S1dyZmIxYWZQb3F2NUx4RE5aSmNUUFdublljXzE3NzA3ODA3NTA6MTc3MDc4NDM1MF9WNA)

说实话，这种一键开通还挺好的，不然这些云平台各种权限找都难得找，要开半天...别问我怎么知道的。

然后就可以在页面上进行 <span style="color: rgb(36,91,219); background-color: inherit">「模型配置」、「消息平台配置」、「 Skills  配置」 </span>了

模型这里，要性价比可以选DeepSeek V3.2，要更强的Agent能力，可以选Kimi-K2

![](https://my.feishu.cn/space/api/box/stream/download/asynccode/?code=N2U5NzFlMmYyZjljMjgxZDBiNjk5YzhhZjE3ZjU3NzdfVFpVNGxGRG03YmY2QldPZHR0TVRlNzRmWGhhaUZjN01fVG9rZW46S3RKV2IwWU1kb1VsQmR4d1hVTGNTM3QwbktlXzE3NzA3ODA3NTA6MTc3MDc4NDM1MF9WNA)

配置完之后，得点击一下应用

消息平台目前支持了 <span style="color: rgb(36,91,219); background-color: inherit">飞书、企微、钉钉、QQ </span>（覆盖了国内主流通讯软件，这点挺赞的）

要接入飞 书需要在飞书开放平台获取 App ID 和 App Secret

它有非常详细的参考文档，就不过多赘述了

![](https://my.feishu.cn/space/api/box/stream/download/asynccode/?code=ZWVkNzZhOTA1YWEwNjdmYTYzMDViNmFlN2VlMzJlNWVfcElvS1RGMk1BMmVOc09sREl1YzE4U3FZUklUeUpQWlBfVG9rZW46U045Z2I4SWlPb1V5OVV4amt3WWM0WDFQbnNoXzE3NzA3ODA3NTA6MTc3MDc4NDM1MF9WNA)

消息平台配置完之后，也得点击一下应用

如果想要配置其他Skills，可清空输入框内容，自行输入Skills。

更多Skills前往openclaw官网获取：

https://clawhub.ai/skills

![](https://my.feishu.cn/space/api/box/stream/download/asynccode/?code=YmFhNjMyNWI2MGFhNDFkMjgzNGI1YWU2NjFhZWU4MGRfTzJ0SWE0cFhCYnBlTEJITUYwdTUydjRsWW5TbG8wcXJfVG9rZW46RUx2cWJ1RXNBb2JuMHJ4N2poOWNxSE1abmxjXzE3NzA3ODA3NTA6MTc3MDc4NDM1MF9WNA)

Skills配置完之后，记得点一下应用

![](https://my.feishu.cn/space/api/box/stream/download/asynccode/?code=ZjFlYTc5OWU5ZjhlZDc0NDFiMTQ1ZWU4ZWNkZGIzMjhfVmpnYWRmNER2TGFtWElydlhEU3Via1gyZTBFRmI0ZmtfVG9rZW46VmN0M2JKNkpqb1VnTlJ4bnlpQmNzUGFNblVnXzE3NzA3ODA3NTA6MTc3MDc4NDM1MF9WNA)

目前有点难受的就是，每次配置都要点击应用，而不是都配置完统一点击应用。但如果是只想单独修改某一块，这点也还是挺灵活的。

如果想要 <span style="color: rgb(36,91,219); background-color: inherit">访问OpenClaw的网页端，可以点击获取网站地址</span>

![](https://my.feishu.cn/space/api/box/stream/download/asynccode/?code=ODdlOWZkOGMyMmZhMDU3NzI2NThhY2IwYmNkM2I3MDJfU3ZrN0ozYmlkMERCWDdvVTVrdDIzOGlMR1VsdDlIR0VfVG9rZW46TEhTTmJ4ZFJ1b1lUZUR4bEpFd2NIa1hoblNlXzE3NzA3ODA3NTA6MTc3MDc4NDM1MF9WNA)

复制得到的网站地址，在浏览器打开

![](https://my.feishu.cn/space/api/box/stream/download/asynccode/?code=NDI2OTE4YTUyMzE5ZjQ1ZjdjYWY3ZWYwY2IzZWEwYmFfbDRjbzBKU0ZPRFNYUEJzdno3VFdnY3hueExVeFM2Z0NfVG9rZW46TzNXMWJtQ256b09wd254dmJUZWMyWW9XbmZjXzE3NzA3ODA3NTA6MTc3MDc4NDM1MF9WNA)

就能通过web界面访问自己的openclaw啦～

![](https://my.feishu.cn/space/api/box/stream/download/asynccode/?code=MmZhYmI0M2E4ODhjNTRiZjFiMTlmMDg0ZWJmZDlhZWVfc0thM0FjcXJhRDFzTFpNQTNnSUZCU1dDQkh3NEhCeGRfVG9rZW46RHpla2JrUklHb1Zzd214WFpRNGM4VWdKbkhoXzE3NzA3ODA3NTA6MTc3MDc4NDM1MF9WNA)

Skills也可以直接在web页面的Skills里面配置

![](https://my.feishu.cn/space/api/box/stream/download/asynccode/?code=MTRlNGMyOGQ2MTMxYTBlZTNjOWRhNmRjZDJjNGIyNWNfM3YwVWZYWnVuZTJ4UFhNRlp2VGk4SVJwSDFoZVVXYlNfVG9rZW46TFlzUGJweGRlb29xc3V4Zmo2MmNteWJvbllkXzE3NzA3ODA3NTA6MTc3MDc4NDM1MF9WNA)

<span style="color: rgb(36,91,219); background-color: inherit">百度千帆官方有不少实用的Skills：</span>

https://cloud.baidu.com/doc/qianfan/s/Mmlda41a2

![](https://my.feishu.cn/space/api/box/stream/download/asynccode/?code=ZjZlN2FiNTBlMTZmNjU4NTE3YmM3OWQ0NjhkNzM4MDZfalNWT0ZSRmFnWGozS3NTZmNCZGttd2haMEpHT2V1SmNfVG9rZW46WUt2bmJUREE2b3JsU294QkZiOWNDNVFublFlXzE3NzA3ODA3NTA6MTc3MDc4NDM1MF9WNA)

我觉得最简单的方式还是把Skills的网址，或者Skills的名字丢给它， <span style="color: rgb(36,91,219); background-color: inherit">让openclaw自动帮我安装各种Skills </span>，这太爽了！

<span style="color: rgb(143,149,158); background-color: inherit">该图片疑似AI生成</span>

![](https://my.feishu.cn/space/api/box/stream/download/asynccode/?code=Y2EzYjA2ODY0YjJmYmQxYWFlOGM1NTc3OTFiYjFlODRfam5PMXdWOEdrM2d1MG5tYmlKQWNUWHhpZ1d6OFNvQVpfVG9rZW46Rkk2UmJ3OWE5b1J0cWp4TlgySmNsVUxGbkNZXzE3NzA3ODA3NTA6MTc3MDc4NDM1MF9WNA)

部分Skills需要apikey，可以从下面这个地址获取

https://console.bce.baidu.com/iam/#/iam/apikey/list

![](https://my.feishu.cn/space/api/box/stream/download/asynccode/?code=ZGYyOGFiOGFiNzkzNTMxMWU2ZDY5ODBjZDc4NjJlYzZfalpKa0dSTWdFWFZCMFB5ZDdkTGR2WFI3Ykp4R01VS0pfVG9rZW46UnQ0NGJ4ZkNHb1RJS3h4eUhVOWNaWE1sbmJhXzE3NzA3ODA3NTA6MTc3MDc4NDM1MF9WNA)

**<span style="color: rgb(36,91,219); background-color: inherit">怎么自定义模型API？ </span>**

被问得最多的就是， <span style="color: rgb(36,91,219); background-color: inherit">怎么接入任意渠道的模型</span>

操作也不难，需要修改一下配置

配置文件位置：

/root/.openclaw/ openclaw.json

需要修改的json配置：

*

*

*

*

*

*

*

*

*

*

*

*

*

*

*

*

*

*

*

*

*

*

*

*

*

*

PS：主要注意models和agents内的配置即可。

公众号复制的json可能格式会乱，可复制丢给AI，让 AI输出一份给你复制使用

<span style="color: rgb(36,91,219); background-color: inherit">只要兼容OpenAI API的模型，都能通过这个方式接入。</span>

**<span style="color: rgb(36,91,219); background-color: inherit">四种实用玩法 </span>**

之前发了openclaw相关的文章，评论区很多朋友就在说，不知道能干嘛，有什么用？

接下来，我结合我的实际体验，给大家展示几个非常实用的场景。

### 场景一：全自动的早报整理员&#x20;

大家每天早上是不是都要花半小时刷各种新闻？微博热搜、科技媒体、行业动态，看得眼花缭乱。

可以直接给 OpenClaw设置定时任务

![](https://my.feishu.cn/space/api/box/stream/download/asynccode/?code=ODg2ZjI2NGIzYjM3NDk3NzkwMDI5MTRkM2EzN2RjZDZfNDhYczJPVUZCclJPSWpDbno4MnNUN2hpaFhFVFZCT2ZfVG9rZW46QXJyMGJkNTZrb1dGd2h4YXMwOGNHeDAwbkJjXzE3NzA3ODA3NTA6MTc3MDc4NDM1MF9WNA)

![](https://my.feishu.cn/space/api/box/stream/download/asynccode/?code=NWRmZjNjNmIyNTY3YTA0ZGI1YzE1NjJhZjJhMDEzOWZfek5BdVZyemFLcmE0NkZoWG9nbUUzVEV6YWlmNUZaUmlfVG9rZW46RFpTVGJ3VDF0b0dRUWF4SVNCN2NYbmw0bldiXzE3NzA3ODA3NTA6MTc3MDc4NDM1MF9WNA)

比如每天早上 9 点，给我推送当天最热的5条AI资讯，会用到百度搜索skill。

![](https://my.feishu.cn/space/api/box/stream/download/asynccode/?code=YWVhMDE2MmRjMTk5NTIyNTMxZmRkMTkzMzY5OWIwMmRfNDB5ckhHSUp4RDNhSzlDNXlMWWVtSXRock9ZSlpxR1NfVG9rZW46UUVmS2JrZFJob2t3MXp4ZHFJcWMyZlV1bmNiXzE3NzA3ODA3NTA6MTc3MDc4NDM1MF9WNA)

凌晨2点，让它到8点的时候给我推送，Seedance2.0最新的消息，真准时呀，而且，整理的信息非常详细

![](https://my.feishu.cn/space/api/box/stream/download/asynccode/?code=MTNlYmYxODFlMDA5ZTU0ZTdhNzZjMDUzYmE2N2I5OTZfZ3JVOE5HUzVmVmU0ZTZsR2pSMGVBaTM3YXhoc2Zpb0ZfVG9rZW46U1lROGJCUEhjb1VWTkV4SW41OGNmajVJbm1iXzE3NzA3ODA3NTA6MTc3MDc4NDM1MF9WNA)

这一点还是非常好用的，特别是这个机器人是可以拉进飞书群聊，是能真正运营社群的。

<span style="color: rgb(36,91,219); background-color: inherit">如果飞书定时任务无效，排查方向是：</span>

1.云服务器的时区是否 Asia/Shanghai，简单来说，就是时间是否是北京时间；

2.飞书提醒失败，可能是机器人权限没配齐，缺少哪些权限 一般openclaw会主动提出来；

3.需要让openclaw把通知对象的飞书Id记录下来。

![](https://my.feishu.cn/space/api/box/stream/download/asynccode/?code=NjFjOGQ4NWI0ODJiNTY5ZThkOGQ1OGE4MWI1OGNhOWRfN29YT1h4bmxIczdvQVBLNkR2YTVtZTBETlpOZm1qa1FfVG9rZW46SGZLd2JlbjdNb1EwNEF4U1dCOWNtTVMwbkhmXzE3NzA3ODA3NTA6MTc3MDc4NDM1MF9WNA)

![](https://my.feishu.cn/space/api/box/stream/download/asynccode/?code=MDhkMzFhOGU3MjdmZDU1Mjk0OGEyNjdlYTZhNTIyM2FfN1BzNkhZbGNsc2pMT3FNQVVmNGNpN3N0UDZ6d05zb29fVG9rZW46VVZlMGJxN1pEb051TGd4SDJ2RGN6eEZsbk1iXzE3NzA3ODA3NTA6MTc3MDc4NDM1MF9WNA)

### 场景二：热点信息收集，一键出图文材料&#x20;

这块对运营同学可能更有帮助

会用到百度搜索、百度百科、百度学术的Skill，最终使用百度智能PPT Skill一键生成PPT。

![](https://my.feishu.cn/space/api/box/stream/download/asynccode/?code=NGZkOTJkYmMwNjhjMDk0ZmU5ZTdjYTRmNjI1MjMxM2VfZUxlY0hyYkNMVlBreWlvbUhZUnI5ZjIyUUZSSHJhYVdfVG9rZW46Q2tUamJISTdzb2RnWW14RWlZZGNYUnpDbktmXzE3NzA3ODA3NTA6MTc3MDc4NDM1MF9WNA)

PPT下载下来长这样：

![](https://my.feishu.cn/space/api/box/stream/download/asynccode/?code=ODdjMDlhNmM2MjY3YmI0MWQ3MDRhZjM3ZDNhOGRmZTVfNm5zY0swZzNPTzZsR3lCYlUySGFOUTZzMGtUTGZ5bWNfVG9rZW46Q29tVGJTQnZNb1pwYXV4djlLQmNuT1J3bnpoXzE3NzA3ODA3NTA6MTc3MDc4NDM1MF9WNA)

整个PPT 27页，图文并茂，排版啥的都很nice，内容也很棒，关键手机上很方便，直接语音就行，在外面都能很便捷的给AI助手布置各种任务。

### 场景三：不知疲倦的 Coding 伙伴&#x20;

作为曾经的程序员，我感觉写代码最痛苦的不是写核心逻辑，而是那些繁琐的配置、改bug等等

通过一个叫 Coding Agent  的Skill，OpenClaw就可以直接调用 Claude Code、Codex等CLI形态的AI编程工具。

![](https://my.feishu.cn/space/api/box/stream/download/asynccode/?code=YjJmODExM2YyZDM4NDM4Y2VlZTQ5OGI3MDFlYTQyN2JfMnNybk1rQThMb0FzdjlocVo0Z2xzRmtDalNCaGgxSHdfVG9rZW46RkN3Z2JqVG9Jb2JMQmR4d0VFMWN1emJibkdmXzE3NzA3ODA3NTA6MTc3MDc4NDM1MF9WNA)

不懂Claude Code怎么安装，没关系，交给OpenClaw吧

![](https://my.feishu.cn/space/api/box/stream/download/asynccode/?code=NjE3OTYyODU4YzUzOGY4ZmFhY2JkM2U2NzQ3OThiNjRfZmRFajZ3aWF2TVNLcEsyektYQlhRNmVyNlhJSDRKZ01fVG9rZW46TEppQ2J1ZjBsb0FQUm54NHN6QWNZY1BhbmNlXzE3NzA3ODA3NTA6MTc3MDc4NDM1MF9WNA)

![](https://my.feishu.cn/space/api/box/stream/download/asynccode/?code=NWZmNWM0YTJlNDMxODgwODRlODY5YzljNWZlZTk1OGFfa2ptRXFmTzk0MTV1SG1OZFlrbkw3NDFwZGZwTnVVcXhfVG9rZW46UVV1eGJKSlp5b0tMWFV4eHkwSWNhR2ZWbnplXzE3NzA3ODA3NTA6MTc3MDc4NDM1MF9WNA)

![](https://my.feishu.cn/space/api/box/stream/download/asynccode/?code=ODliZjgyMGQ2MWViZjYzMjgxNDkyYjgyOWNhMjZjZGNfRm1EMm53cEJVdVA1d2pGU08xdzJ1OW1iUDFiZnFwRUpfVG9rZW46VGpLdGJYUzZLb0VmbEl4SnpRYmNJRWtybldnXzE3NzA3ODA3NTA6MTc3MDc4NDM1MF9WNA)



它三下五除二就把Claude Code安装完成了，这可比我自己动手爽多了

然后就是口喷需求，让OpenClaw帮我操纵Claude Code开发

它甚至可以把开发完成的代码文件直接发给我

![](https://my.feishu.cn/space/api/box/stream/download/asynccode/?code=NDY2ZWU1YzU1YTRlNTQyY2YyMjQ4MmMwNzNjODVkYWVfZUIyV0VGQlEzRHNRQ2ZRNTdqc3FDQ2Vic2VnUVUxcThfVG9rZW46VzZlSmJWSjJob09mRm54RVdVNmNGcEZKbm1kXzE3NzA3ODA3NTA6MTc3MDc4NDM1MF9WNA)

下载下来，双击打开就能愉快的玩耍啦～

![](https://my.feishu.cn/space/api/box/stream/download/asynccode/?code=ZDdiMzRlYzI5M2U3N2NmMDEzNWZjNDUxYjA4ZDNkYmZfV2k5MEx4bHdmUEJwdlk5ZzNaM2ZZY1o0WjRYTmRPN1NfVG9rZW46UnpmbWJMZndCb0g3OXJ4S2ZsRGNxNml0bkFjXzE3NzA3ODA3NTA6MTc3MDc4NDM1MF9WNA)

那其实也可以把复杂的需求丢给OpenClaw，让它操纵Claude Code去开发，OpenClaw不是还会操控浏览器嘛，开发完毕让它自己测，有Bug又丢给Claude Code改～

嗯嗯，想想都美滋滋，不过token估计会爆炸，但买各家的coding plan就好了，成本可控。

### 场景四： 多Agent  头脑风暴&#x20;

OpenClaw还有个非常🐂🍺的能力，多Agent分身，这块能有很多玩法，比如Agent团队啥的

做头脑风暴其实也非常不错，比如我让它分出多个Agent，分别扮演： <span style="color: rgb(36,91,219); background-color: inherit">达芬奇、宫崎骏、乔布斯、苏格拉底、 凯文·凯利，帮我进行3轮脑暴</span>

<span style="color: rgb(36,91,219); background-color: inherit">主题是： AI时代下的刚成立的一人公司，应该怎么招人，怎么控制成本，又能把效率提升到极致？</span>

![](https://my.feishu.cn/space/api/box/stream/download/asynccode/?code=YzA1MmVlNWY3OTdmNWVlMWQ2ZDdlMmRjMjgwOGVmNWFfWFBGM3BjWllORWRwRmR6VmhtZjQ3aEgwRWkxVFIzR1pfVG9rZW46V1ZUaWJIN2c2b1BySjV4Nk9MRGNuVllzblVmXzE3NzA3ODA3NTA6MTc3MDc4NDM1MF9WNA)

这个任务我看了一下，跑得还蛮久的，花了7分钟左右

最终诞生了一个详细的markdown文件（将近400行内容），详细的记录了3轮脑暴的过程，和这几位"大咖"给出的建议。

![](https://my.feishu.cn/space/api/box/stream/download/asynccode/?code=M2MzYTVjMTZmM2RjNmExMTc5MmExYmM4M2QzZDlmZThfbEFyV3FEYVFQVVNkU0QzdVJ2MVlVRU9GY0NCNXRWR2JfVG9rZW46UHVlR2JBVWRkb3JCTXJ4STdKZWNtdW0wbjBnXzE3NzA3ODA3NTA6MTc3MDc4NDM1MF9WNA)

我个人是挺喜欢这种能自己DIY的 AI助手，因为它的上限无限高。



**<span style="color: rgb(36,91,219); background-color: inherit">OpenClaw 为什么能做到这么灵活？ </span>**

核心在于三个点： <span style="color: rgb(36,91,219); background-color: inherit">Skills、MCP和系统级权限。</span>

### 1. Skills：给 AI 装上三头六臂&#x20;

OpenClaw 本身只是一个大脑。但它拥有一个类似手机 App Store 的 Skills社区。

目前社区已经贡献了将近 2000 个Skills。

![](https://my.feishu.cn/space/api/box/stream/download/asynccode/?code=YTcxZjdmYzcwYjc5NWM1ZjNlYmFmYmI0ZTI1M2JiODBfWWc4dDBkcU9BaFdZMzRkVVppTkxiNVlkT1NQTE9mNDZfVG9rZW46V2Q4UmJRbnExb1VqZnp4anFSdGNNTjdObjhlXzE3NzA3ODA3NTA6MTc3MDc4NDM1MF9WNA)

你想听播客？装个播客生成插件，丢个文章链接，它自动给你转成 MP3。

你想控制智能家居？装个 HomeAssistant 插件，你可以让它帮你关灯、调空调温度。

你想点外卖？甚至有大神逆向了外卖平台的 API，让 Agent 帮你查外卖还有多久送到。

这意味着，它的能力边界，完全取决于社区的想象力。

### 2. MCP 协议：万能插头&#x20;

MCP（模型上下文协议）是 Anthropic 推出的一个标准，旨在让大模型能标准化地连接外部数据。

OpenClaw 同样完美支持 MCP。

这就像是给 AI 统一了插座标准。通过 MCP，你可以轻松地把 Google 日历、Gmail、Notion、甚至你公司的内部数据库连接到 OpenClaw 上。

也可以通过百度千帆MCP广场完备的生态，跟各种丰富的应用建立连接～

![](https://my.feishu.cn/space/api/box/stream/download/asynccode/?code=NjVlMThmYTc0YWE3Mzc0M2QzYzdkNDJjODM4YWEyZTNfM3psclp6ZGhTNzdZek9iNmZHUk5yTU5NdXpJMHRFSDlfVG9rZW46R3NKOWJWSWlKb3l0Z3J4ZWFtU2NZNlFKblZkXzE3NzA3ODA3NTA6MTc3MDc4NDM1MF9WNA)

### 3. 系统级权限：放权才能自由&#x20;

这其实是双刃剑，也是 OpenClaw 最强大，最有魅力的地方。

它不像网页版 AI 那样被困在沙盒里。它拥有读取你硬盘文件、执行 Shell 命令的权限。

正因为有了这个权限，它才能帮你整理桌面、批量重命名文件、部署环境、甚至监控屏幕。

当然，这也带来了安全风险。所以我在文章开头提到，最好是用独立的服务器或者虚拟机来运行，把风险隔离出去。

**<span style="color: rgb(36,91,219); background-color: inherit">新手入坑建议 </span>**

看到这里，可能很多朋友已经跃跃欲试了。作为过来人，给大家几个避坑建议。

### 1. 关于硬件&#x20;

别被网上说的买 Mac Mini 吓退，或者盲目跟风。

如果你只是想尝鲜，体验一下简单的聊天、搜索、定时任务功能，一台普通的电脑，或者 免费白嫖百度智能云一个月的 2 核 4G 云服务器就足够了。

等你真的觉得它好用，想让他跑本地大模型、处理视频图像了，再考虑升级硬件也不迟。

### 2. 关于网络&#x20;

因为 OpenClaw 支持的很多Skills和应用是国外的，所以网络环境是必须解决的问题。有这块需求的朋友，在使用百度智能云部署的时候，服务器地域可以选择香港。

如果只玩国内生态，可以接入飞书或者钉钉作为前端，后端模型可以尝试接入国内优秀的模型，比如 MiniMax 或者 GLM、Kimi。

Skills和MCP可以选择百度千帆生态

另外，OpenClaw非常消耗token，各家的Coding Plan量大管饱，是更优选择。



### 3. 关于安全&#x20;

重要的事情说三遍：

不要在存有重要隐私数据的主力机上裸奔运行！

不要在存有重要隐私数据的主力机上裸奔运行！

不要在存有重要隐私数据的主力机上裸奔运行！

给它一个独立的 VPS（开头讲的白嫖云服务器），或者在家里的 NAS 上开个 Docker 容器给它。

毕竟它有执行命令的权限，万一 AI 抽风或者被黑客入侵，把你的文件全删了，哭都来不及。

**<span style="color: rgb(36,91,219); background-color: inherit">最后 </span>**

在测试 OpenClaw 的这几天，我常常有一种恍惚感。

看着屏幕上自动跳动的字符，看着那些自动完成的任务，我意识到，我们正在经历人机交互的一次巨大变革。

过去几十年，操作系统（OS）的核心是 图形界面（GUI）。我们需要学习怎么点击图标、怎么用菜单、怎么管理文件。

但未来的操作系统，肯定不再需要这些了。

<span style="color: rgb(36,91,219); background-color: inherit">OpenClaw 展示了另一种可能：自然语言就是操作系统。</span>

你不需要知道文件存在哪个文件夹里，你只需要告诉 Agent：帮我找到上个月那份合同。

你不需要知道怎么用 Photoshop 去水印，你只需要告诉 Agent：把这张图弄干净。

<span style="color: rgb(36,91,219); background-color: inherit">工具的属性正在慢慢淡化，伙伴的属性正在增强。</span>

对于我们这些普通人来说，这意味着什么？

意味着杠杆。

以前，一个人要运营一个公众号、维护一个网站、开发一个 App，可能需要三头六臂，累得半死。

现在，只要你把它用好，你就可以拥有一支 24 小时工作的 赛博团队。

目前OpenClaw 还在飞速迭代中，也在不断调整方向。

它绝对不是完美的，现在还有很多 Bug，有时候也会有点笨。

但它代表的趋势是不可逆转的。

不管你是程序员、自媒体人，还是普通的职场白领，我都强烈建议你去试一 试，哪怕只是部署一个最简单的版本。

去感受一下，当你睡觉时，有人在替你干活的那种感觉。

<span style="color: rgb(36,91,219); background-color: inherit">当然，目前性价比最高的尝鲜方式，还是百度智能云的0.01元/月，我看了一下，每天限量500台，手慢无。</span>

如果你对部署 OpenClaw 还有疑问，或者有什么更有趣的玩法，欢迎在评论区交流。

我是袋鼠帝，一个致力于把 AI 变成生产力的博主。

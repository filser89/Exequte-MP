//index.js
//获取应用实例
import { promisifyAll, promisify } from 'miniprogram-api-promise';

const wxp = {}
const app = getApp()

Page({
  data: {
    motto: 'Hello World',
    userInfo: {},
    hasUserInfo: false,
    canIUse: wx.canIUse('button.open-type.getUserInfo')
  },
  //事件处理函数
  bindViewTap: function() {
    wxp.navigateTo({
      url: '../logs/logs'
    })
  },
  onLoad: function () {
    promisifyAll(wx, wxp)
    if (app.globalData.userInfo) {
      this.setData({
        userInfo: app.globalData.userInfo,
        hasUserInfo: true
      })
    } else if (this.data.canIUse){
      // 由于 getUserInfo 是网络请求，可能会在 Page.onLoad 之后才返回
      // 所以此处加入 callback 以防止这种情况
      app.userInfoReadyCallback = res => {
        this.setData({
          userInfo: res.userInfo,
          hasUserInfo: true
        })
      }
    } else {
      // 在没有 open-type=getUserInfo 版本的兼容处理
      wxp.getUserInfo({
        success: res => {
          app.globalData.userInfo = res.userInfo
          this.setData({
            userInfo: res.userInfo,
            hasUserInfo: true,
            wxpUsed: true
          })
        }
      })
    }
  },
  getUserInfo: function(e) {
    console.log(e)
    app.globalData.userInfo = e.detail.userInfo
    this.setData({
      userInfo: e.detail.userInfo,
      hasUserInfo: true
    })
  },
  setStrings() {
    const page = this
    wxp.request({
      url: `${app.globalData.BASE_URL}/pages`,
      method: 'post',
      header: app.globalData.headers,
      data: ['title', 'dog', 'focus'],
      success: res => page.setData({strings: res.data.data}),
      fail: e => console.log("Failed!!!", e),
      complete: () => console.log("Completed")
    })
  }
})

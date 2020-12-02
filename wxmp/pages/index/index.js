//index.js
//获取应用实例
import { promisifyAll, promisify } from 'miniprogram-api-promise';
import { setStrings, getCurrentUser } from '../../utils/requests';

const wxp = {}
const app = getApp()

Page({
  data: {
    motto: 'Hello World',
    userInfo: {},
    hasUserInfo: false,
    canIUse: wx.canIUse('button.open-type.getUserInfo'),
    keys: ['title', 'dog', 'focus']
  },
  //事件处理函数
  bindViewTap: function() {
    wxp.navigateTo({
      url: '../logs/logs'
    })
  },
  async onLoad() {
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
    // const strings = await setStrings()
    // console.log(await strings)
    this.setData({strings: await setStrings(this.data.keys)})
    this.setData({user: await getCurrentUser()})

  },
  getUserInfo: function(e) {
    console.log(e)
    app.globalData.userInfo = e.detail.userInfo
    this.setData({
      userInfo: e.detail.userInfo,
      hasUserInfo: true
    })
  },

  getSessions() {
    const page = this
    wxp.request({
      url: `${app.globalData.BASE_URL}/training_sessions`,
      header: app.globalData.headers,
      success: res => page.setData({sessions: res.data.data}),
      fail: e => console.log("Failed!!!", e),
      complete: () => console.log("Completed")

    })
  },
  getSession(){
    const page = this
    wxp.request({
      url: `${app.globalData.BASE_URL}/training_sessions/34`,
      header: app.globalData.headers,
      success: res => page.setData({session: res.data.data}),
      fail: e => console.log("Failed!!!", e),
      complete: () => console.log("Completed")

    })
  },
  createBooking(){
    const page = this
    wxp.request({
      url: `${app.globalData.BASE_URL}/training_sessions/22/bookings`,
      method: 'post',
      header: app.globalData.headers,
      data: {"booked_with": "voucher"},
      success: res => console.log("Booking created!", res),
      fail: e => console.log("Failed!!!", e),
      complete: () => console.log("Completed")
    })
  },
  cancelBooking() {
    wxp.request({
      url: `${app.globalData.BASE_URL}/bookings/82/cancel`,
      method: 'put',
      header: app.globalData.headers,
      data: {},
      success: res => console.log("Booking canceled!", res),
      fail: e => console.log("Failed!!!", e),
      complete: () => console.log("Completed")
    })
  },
  getCurrentUser() {
    wxp.request({
      url: `${app.globalData.BASE_URL}/users/info`,
      header: app.globalData.headers,

      success: res => wx.setStorageSync('current_user', res.data.data),
      fail: e => console.log("Failed!!!", e),
      complete: () => console.log("Completed")
    })
  }
})

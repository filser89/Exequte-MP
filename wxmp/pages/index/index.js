//index.js
//获取应用实例

import {
  setStrings,
  getCurrentUser,
  getMembershipTypes,
  buyMembership,
  addUserToQueue,
  getInstructorSessions,
  getAttendanceList,
  createBooking,
  cancelBooking,
  getSession,
  getSessions,
  takeAttendance
} from '../../utils/requests';


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
  bindViewTap: function () {
    wxp.navigateTo({
      url: '../logs/logs'
    })
  },
  async onLoad() {
    if (app.globalData.userInfo) {
      this.setData({
        userInfo: app.globalData.userInfo,
        hasUserInfo: true
      })
    } else if (this.data.canIUse) {
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

    this.setData({
      strings: await setStrings(this.data.keys)
    })
    // this.setData({
    //   user: await getCurrentUser()
    // })
    // this.setData({
    //   membershipTypes: await getMembershipTypes()
    // })
    // this.setData({
    //   instructorSessions: await getInstructorSessions()
    // })
    // this.setData({
    //   attendanceList: await getAttendanceList()
    // })
    this.setData({
      sessions: await getSessions()
    })

    getAttendanceList
  },
  getUserInfo: function (e) {
    console.log(e)
    app.globalData.userInfo = e.detail.userInfo
    this.setData({
      userInfo: e.detail.userInfo,
      hasUserInfo: true
    })
  },

  getSession() {
    getSession()
  },
  createBooking() {
    createBooking()
  },
  cancelBooking() {
    cancelBooking()
  },

  buyMembership() {
    buyMembership()
  },
  async queueUp() {
    addUserToQueue()
  },

  takeAttendance() {
    takeAttendance()
  }

})
//index.js
//获取应用实例

import {
  getStrings,
  getCurrentUser,
  getBanner,
  getSessions
} from '../../utils/requests/index';

Page({
  data: {
    motto: 'Hello World',
    userInfo: {},
    hasUserInfo: false,
    canIUse: false,
    keys: ['title', 'dog', 'focus'],
  },

  async onLoad() {
    
    wx.setStorageSync('selectedTab', 1)
    console.log('index page', wx.getStorageSync('selectedTab'))

      wx.showLoading({
        title: 'Just a sec..',
      })

const strings = await getStrings(this.data.keys)
const user = await getCurrentUser()
const banner = await getBanner()
const sessions =  await getSessions()
Promise.all([strings, user, banner, sessions]).then((values) => {
  console.log('values', values)
  this.setData({strings, user, banner, sessions})
  wx.hideLoading()
})




    // this.setData({
    //   strings: await getStrings(this.data.keys)
    // })
    // this.setData({
    //   user: await getCurrentUser()
    // })
    // this.setData({
    //   banner: await getBanner()
    // })
  
    // this.setData({
    //   sessions: await getSessions()
    // })
  },

  onShow() {

  },
  getUserInfo: function (e) {
    console.log(e)
    app.globalData.userInfo = e.detail.userInfo
    this.setData({
      userInfo: e.detail.userInfo,
      hasUserInfo: true
    })
  },

  bindGetUserInfo ({detail}) {
    console.log(detail.userInfo)
    wx.navigateTo({
      url: `../../pages/profile-update/profile-update`
    })

  }

})
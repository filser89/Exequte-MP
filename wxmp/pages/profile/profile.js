// pages/profile/profile.js
Page({

  /**
   * Page initial data
   */
  data: {

  },

  /**
   * Lifecycle function--Called when page load
   */
  onLoad(){
    wx.setStorageSync('selectedTab', 2)
    console.log('profile page', wx.getStorageSync('selectedTab'))
  },
  onShow() {

  },
})
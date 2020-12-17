// pages/about/about.js
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
    wx.setStorageSync('selectedTab', 0)
    console.log('about page', wx.getStorageSync('selectedTab'))
  },
  onShow() {


  },

})
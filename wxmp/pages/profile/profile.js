// pages/profile/profile.js
import {getUserDetails} from "../../utils/requests/index"
Page({

  /**
   * Page initial data
   */
  data: {
    user: {}
  },

  /**
   * Lifecycle function--Called when page load
   */
  async onLoad(){
    wx.setStorageSync('selectedTab', 2)
    console.log('profile page', wx.getStorageSync('selectedTab'))
    const user = wx.getStorageSync('current_user')
    console.log('id', user.user.id)
    this.setData({
      user: await getUserDetails(user.user.id)
    })
  },

  navigateToMyClasses(){
    wx.navigateTo({
      url: `../../pages/my-classes/my-classes`
    })
  },
  navigateToProfileUpdate(){
    wx.navigateTo({
      url: `../../pages/profile-update/profile-update`
    })
  }

})
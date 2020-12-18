// pages/profile-update/profile-update.js

import {getUserDetails} from '../../utils/requests/index'
Page({

  /**
   * Page initial data
   */
  data: {},

  /**
   * Lifecycle function--Called when page load
   */
  async onLoad (options) {
    const user = wx.getStorageSync('current_user')
    console.log('id', user.user.id)
    this.setData({user: await getUserDetails(user.user.id)})
  },
  formSubmit: function(e) {
    console.log('Submit!')
    console.info('value:', e.detail.value)
  },
  handleBirthdayChange({detail}){
    console.log('bd changed', detail)
    this.data.user.birthday = detail.birthday
    console.log('bd changed', this.data.user)
  
  }
})
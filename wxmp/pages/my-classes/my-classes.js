import {getUsersBookings} from "../../utils/requests/index"
// pages/my-classes/my-classes.js
Page({

  /**
   * Page initial data
   */
  data: {
    bookings: [],
    selected: 0
  },

  /**
   * Lifecycle function--Called when page load
   */
  async onLoad(options) {
    wx.setStorageSync('selectedTab', -1)
    console.log('non-tabbar page', wx.getStorageSync('selectedTab'))

    this.setData({bookings: await getUsersBookings()})
    console.log("On load", this.data.bookings)
  },

  switchTab({currentTarget}){
    const {selected} = currentTarget.dataset
    this.setData({selected})
  }

})
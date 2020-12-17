// pages/booking-confirmation/booking-confirmation.js
import {getBooking} from '../../utils/requests/index.js'
Page({

  /**
   * Page initial data
   */
  data: {

  },

  /**
   * Lifecycle function--Called when page load
   */
  async onLoad(options) {
    this.setData({booking: await getBooking(options.bookingId)})
  }

 
})
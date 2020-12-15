// pages/booking/booking.js
import {getSession, getMembershipTypes} from '../../utils/requests/index.js'
const app = getApp()
Page({

  /**
   * Page initial data
   */
  data: {
    selected: 'drop-in',
    btnPattern: {
      action: 'navigateToPayment',
      text: 'PAY'
    }
  },

  /**
   * Lifecycle function--Called when page load
   */
 async onLoad (options) {
    console.log(options)
    const {sessionId} = options
    this.setData({
      session: await getSession(sessionId),
      membershipTypes: await getMembershipTypes()
    })
  },
  
  handleOptionChange({detail}){
    this.setData(detail)
    console.log("selected", this.data.selected)
  }
})
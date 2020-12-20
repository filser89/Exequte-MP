// pages/profile-update/profile-update.js
import WxValidate from '../../utils/WxValidate'
import {
  getUserDetails,
  updateUser
} from '../../utils/requests/index'
Page({

  /**
   * Page initial data
   */
  data: {},

  /**
   * Lifecycle function--Called when page load
   */
  async onLoad(options) {
    console.log('profile-update', options)
    this.setData(options)
    this.initValidate()
    const user = wx.getStorageSync('current_user')
    console.log('id', user.user.id)
    this.setData({
      user: await getUserDetails(user.user.id)
    })
  },
  formSubmit({
    detail
  }) {
    console.info('value:', detail.value)
    const params = detail.value
    // validation     
    if (!this.WxValidate.checkForm(params)) {
      this.handleValidationFailure()
      return false
    }
    console.log('Authentication successful');
    // Start submission      
    this.submitRequest(params)
  },

  async submitRequest(params) {
    // console.log('submitRequest', params)
    const res = await updateUser(this.data.user.id, params)
    console.log("RES", res)
if (this.data.sessionId){
  this.redirectToBooking()
} else {
  wx.showToast({
    title: res.message,
    icon: 'none',
    duration: 1500,
})
wx.setStorageSync('current_user.user', res.user)
}

  },

  redirectToBooking(){
    wx.redirectTo({
      url: `../../pages/booking/booking?sessionId=${this.data.sessionId}`,
    })
  },


  handleValidationFailure() {
    const error = this.WxValidate.errorList[0]
    wx.showToast({
      title: error.msg,
      icon: 'none',
      duration: 1000,
    })
  },

  initValidate() {
    const rules = {
      first_name: {
        required: true
      },
      last_name: {
        required: true
      },
      phone: {
        required: true
      },
      email: {
        required: true
      },
      emergency_name: {
        required: true
      },
      emergency_phone: {
        required: true
      }

    }
    const messages = {
      first_name: {
        required: "First Name is a required field"
      },
      last_name: {
        required: "Last Name is a required field"
      },
      phone: {
        required: "Phone is a required field"
      },
      email: {
        required: "Email is a required field"
      },
      emergency_name: {
        required: "Emergency Contact Name is a required field"
      },
      emergency_phone: {
        required: "Emergency Contact  Phone is a required field"
      }
    }
    this.WxValidate = new WxValidate(rules, messages)
  }
})
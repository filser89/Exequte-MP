// pages/booking/booking.js
const computedBehavior = require('miniprogram-computed')
import {
  getSession,
  getMembershipTypes
} from '../../utils/requests/index.js'
const app = getApp()
Page({

  /**
   * Page initial data
   */
  data: {
    session: {},
    selected: '',
    selectedMembershipTypeId: '',
    btnPattern: {},
    membershipDate: ''
  },

  /**
   * Lifecycle function--Called when page load
   */
  async onLoad(options) {
    console.log(options)
    const {
      sessionId
    } = options

    const session = await getSession(sessionId)
    const selected = this.setSelected(session.access_options)
    const btnPattern = this.setBtnPattern(selected)
    const membershipDate = session.membership_date
    this.setData({
      session,
      selected,
      btnPattern,
      membershipDate,
      membershipTypes: await getMembershipTypes(),
    })
  },

  handleOptionChange({
    detail
  }) {
    this.setData(detail)
    console.log("detail", detail)
    this.setBtnPattern(detail.selected)
  },
  setSelected(accessOptions) {
    return accessOptions.hasOwnProperty('drop-in') ? 'drop-in' : 'free'
  },
  handleDateChange({
    detail
  }) {
    console.log("handleDateChange", detail)
    const {
      membershipDateString
    } = detail
    this.setData({
      membershipDate: new Date(membershipDateString)
    })
    console.log("handleDateChange", this.data.membershipDate)
  },

  setBtnPattern(accessOption) {
    console.log("setBtnPattern", accessOption)
    switch (accessOption) {
      case 'free':
        this.setData({
          btnPattern: {
            action: 'bookClass',
            text: 'JOIN FOR FREE',
            params: {
              booked_with: 'free'
            }
          }
        })
        this.
        break
      case 'drop-in':
        this.setData({
          btnPattern: {
            action: 'bookClass',
            text: 'PAY',
            params: {
              booked_with: 'drop-in'
            }
          }
        })
        break
      case 'buy-membership':
        this.setData({
          btnPattern: {
            action: 'buyMembership',
            text: 'PAY',
            params: {
              start_date: this.data.membershipDate
            }
          }
        })
        break;
      case 'voucher':
        console.log("setBtnPattern", 2)
        this.setData({
          btnPattern: {
            action: 'bookClass',
            text: 'Use Voucher',
            params: {
              booked_with: 'voucher'
            }
          }
        })
        break
      case 'membership':
        this.setData({
          btnPattern: {
            action: 'bookClass',
            text: 'BOOK',
            params: {
              booked_with: 'membership',
              membership_id: this.data.session.usable_membership.id
            }
          }
        })
    }
  }
})
// pages/class-info/class-info.js
import {
  getSession,
  getInstructor
} from '../../utils/requests/index'
Page({

  /**
   * Page initial data
   */
  data: {
    session: {},
    instructor: {},
    btnPattern: {}
  },

  /**
   * Lifecycle function--Called when page load
   */
  async onLoad(options) {
    const {
      sessionId,
      instructorId
    } = options
    this.setData({
      session: await getSession(sessionId),
      instructor: await getInstructor(instructorId)
    })
    
    this.setBtnPattern(this.data.session)
  },
  async handleChangedDate({
    detail
  }) {
    const {
      sessionId,
      instructorId
    } = detail
    this.setData({
      session: await getSession(sessionId),
      instructor: await getInstructor(instructorId)
    })
    this.setBtnPattern(this.data.session)
  },
  // async setPageData(obj) {
  //   const {
  //     sessionId,
  //     instructorId
  //   } = obj
  //   console.log(obj)
  //   this.setData({
  //     session: await getSession(sessionId),
  //     instructor: await getInstructor(instructorId)
  //   })
  // },
  handleQueuedUp({
    detail
  }) {
    const session = detail
    this.setData({
      session
    })
    console.log(this.data.session)
    this.setBtnPattern(this.data.session)
  },

  setBtnPattern(session) {
    const btnPattern = {
      disabled: session.btn_pattern.disabled,
      text: session.btn_pattern.text,
      action: session.btn_pattern.action,
      sessionId: session.id
    }
    this.setData({
      btnPattern
    })
  }
})
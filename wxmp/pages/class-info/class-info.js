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

  },

  /**
   * Lifecycle function--Called when page load
   */
  async onLoad(options) {
    this.setPageData(options)   
  },
 async updateSession({detail}){
    this.setPageData(detail)
  },
  async setPageData(obj){
    const {sessionId, instructorId} = obj
    console.log(obj)
    this.setData({
      session: await getSession(sessionId),
      instructor: await getInstructor(instructorId)
    })
  },
  handleQueuedUp({detail}){
    const session = detail
    this.setData({session})
    console.log(this.data.session)
  }
})
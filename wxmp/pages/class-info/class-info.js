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
    // const {
    //   sessionId,
    //   instructorId,
    //   trainingId
    // } = options
    // console.log(options)
    // this.setData({
    //   session: await getSession(sessionId),
    //   instructor: await getInstructor(instructorId)
    // })
    this.setPageData(options)   
  },
 async updateSession({detail}){
    console.log("updateSession", detail)
    // const {newSessionId, newInstructorId} = detail
    this.setPageData(detail)
  },
  async setPageData(obj){
    const {sessionId, instructorId} = obj
    console.log(obj)
    this.setData({
      session: await getSession(sessionId),
      instructor: await getInstructor(instructorId)
    })
  }

})
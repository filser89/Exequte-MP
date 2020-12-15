// pages/index/components/SessionItem/SessionItem.js
Component({
  /**
   * Component properties
   */
  properties: {
    session: Object
  },

  /**
   * Component initial data
   */
  data: {

  },

  /**
   * Component methods
   */
  methods: {
    navigateToClassInfo(e) {
      const {sessionId, instructorId} = e.currentTarget.dataset  
      wx.navigateTo({
        url: `../class-info/class-info?sessionId=${sessionId}&instructorId=${instructorId}`,
      })
    },
    handleQueuedUp({detail}){
      const session = detail
      this.setData({session})
      console.log(this.data.session)
    }
  }
})
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
    user: {}
  },
  lifetimes: {
    attached() {
      const user = wx.getStorageSync('current_user')
      this.setData({
        user: user.user
      })
      console.log('sessionItemAttached', this.data.user)
    },
  },
  /**
   * Component methods
   */
  methods: {
    navigateToClassInfo(e) {
      const {
        sessionId,
        instructorId
      } = e.currentTarget.dataset
      wx.navigateTo({
        url: `../class-info/class-info?sessionId=${sessionId}&instructorId=${instructorId}`,
      })
    },
    handleQueuedUp({
      detail
    }) {
      const session = detail
      this.setData({
        session
      })
      console.log(this.data.session)
    }
  }
})
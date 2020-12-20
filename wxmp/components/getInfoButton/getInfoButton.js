// components/getInfoButton/getInfoButton.js
Component({
  /**
   * Component properties
   */
  properties: {
    itemId: Number
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

    bindGetUserInfo (e) {
      console.log('GetUserInfo', e)
      console.log(e.detail.userInfo)
      wx.navigateTo({
        url: `../../pages/profile-update/profile-update?sessionId=${this.data.itemId}`
      })
  
    }
  }
})

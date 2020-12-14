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
      const id = e.currentTarget.dataset.id
      wx.navigateTo({
        url: `../class-info/class-info?id=${id}`,
      })
    }
  }
})
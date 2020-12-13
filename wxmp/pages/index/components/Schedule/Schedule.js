// pages/index/components/Schedule/Schedule.js
Component({
  /**
   * Component properties
   */
  properties: {
    sessions: Object
  },

  /**
   * Component initial data
   */
  data: {
    current: 0
  },

  /**
   * Component methods
   */
  methods: {
    toggleCurrent(e) {

      this.setData({current: e.target.dataset.index})
      console.log("current changed", this.data.current)
    }
  },

  logSession(e) {
    console.log(e.target)
  }
})

// pages/index/components/DateSessions/DateSessions.js
Component({
  /**
   * Component properties
   */
  properties: {
    sessions: {
      type: Array,
      value: ['a', 'b']
    },
  },

  /**
   * Component initial data
   */
  data: {

  },
  lifetimes: {
    attached(){
      console.log("properties", this.properties)
    }
  },

  /**
   * Component methods
   */
  methods: {

  }
})

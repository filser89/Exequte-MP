// components/ActionButton/ActionButton.js
Component({
  /**
   * Component properties
   */
  properties: {

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
    takeAction(e){
      console.log("Inside take action", e.currentTarget.dataset.action)
    }
  }
})

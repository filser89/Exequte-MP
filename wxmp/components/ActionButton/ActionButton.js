// components/ActionButton/ActionButton.js
import {createBooking, addUserToQueue} from '../../utils/requests/index'
Component({
  /**
   * Component properties
   */
  properties: {
    action: String,
    itemId: Number,
    btnDisabled: Boolean
  },

  /**
   * Component initial data
   */
  data: {

  },
  lifetimes: {
    attached(){}
  },

  /**
   * Component methods
   */
  methods: {
    takeAction(e){
      const {action} =  e.currentTarget.dataset
      console.log("in action", e.currentTarget.dataset)
      if(action == "navigateToBooking"){
        this.navigateToBooking()
      } else if(action == "queueUp"){
        this.queueUp()
      }
    },
    
    navigateToBooking(){
      wx.navigateTo({
        url: `../../pages/booking/booking?sessionId=${this.properties.itemId}`,
      })
    },

    async queueUp(){
      const session = await addUserToQueue(this.properties.itemId)
      console.log(session)
      this.triggerEvent('queuedup', session)
    }
  }
})

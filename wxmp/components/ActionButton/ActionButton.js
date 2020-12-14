// components/ActionButton/ActionButton.js
import {createBooking, addUserToQueue} from '../../utils/requests/index'
Component({
  /**
   * Component properties
   */
  properties: {
    action: String,
    itemId: Number
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
      const action =  e.currentTarget.dataset.action
      if(action == "navigateToBooking"){
        this.navigateToBooking()
      } else if(action == "queueUp"){
        this.queueUp()
      }
    },
    
    navigateToBooking(){
      wx.navigateTo({
        url: `../../pages/booking/booking?id=${this.properties.itemId}`,
      })
    },

    queueUp(){
      addUserToQueue(this.properties.itemId)
    }
  }
})

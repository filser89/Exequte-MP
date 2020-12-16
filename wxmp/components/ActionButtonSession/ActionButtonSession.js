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
      } else if (action == "makePayment"){
        this.makePayment()
      } else if (action == "bookClass"){
        this.bookClass()
      } else {
        console.log("Unknow action")
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
    },
    async makePayment(){
      console.log("Payment is made")
      this.triggerEvent('classbooked')
    },
  }
})

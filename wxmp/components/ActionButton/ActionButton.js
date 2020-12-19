// components/ActionButton/ActionButton.js
import {createBooking, buyMembership, addUserToQueue, } from '../../utils/requests/index'
Component({
  /**
   * Component properties
   */
  properties: {
    action: String,
    itemId: Number,
    btnDisabled: {
      value: false,
      type: Boolean
    },
    params: Object
  },

  /**
   * Component initial data
   */
  data: {

  },
  lifetimes: {
    attached(){
      // console.log(this.data)
    }
  },

  /**
   * Component methods
   */
  methods: {
    takeAction(e){
      const {action} =  e.currentTarget.dataset
      console.log("in action", e.currentTarget.dataset)
      if(action == "buyMembership"){
        this.buyMembership()
      } else if(action == "bookClass"){
        this.bookClass()
      } else if(action == "queueUp"){
        this.queueUp()
      } else if(action == "navigateToBooking"){
        this.navigateToBooking()
      } else if(action == "reLaunchToMyClasses"){
        this.reLaunchToMyClasses()
      } else if(action == "reLaunchToIndexPage"){
        this.reLaunchToIndexPage()
      } else {
        console.log("Unknow action")
      }
    },
    
    async buyMembership(){
      console.log("buyMembership",this.data.params)
      const membership = await buyMembership(this.data.itemId, this.data.params)
      console.log("buyMembership", membership)
      this.triggerEvent('membershipbought')
    },

    async bookClass(){
      console.log("bookClass", this.data)
      const booking = await createBooking(this.data.itemId, this.data.params)
 wx.redirectTo({
   url: `../../pages/booking-confirmation/booking-confirmation?bookingId=${booking.id}`,
 })
    },

    async queueUp(){
      const session = await addUserToQueue(this.properties.itemId)
      console.log(session)
      this.triggerEvent('queuedup', session)
    },

    navigateToBooking(){
      wx.navigateTo({
        url: `../../pages/booking/booking?sessionId=${this.properties.itemId}`,
      })
    },

    reLaunchToMyClasses(){
      wx.reLaunch({
        url: '../../pages/my-classes/my-classes'
      })
    },
    reLaunchToIndexPage(){
      wx.reLaunch({
        url: '../../pages/index/index',
      })
    }

  }
})

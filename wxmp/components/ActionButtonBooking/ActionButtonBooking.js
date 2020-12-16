// components/ActionButtonBooking/ActionButtonBooking.js
import {createBooking, buyMembership} from '../../utils/requests/index'
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
      console.log(this.data)
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
      }  else {
        console.log("Unknow action")
      }
    },
    


    async buyMembership(){
      console.log("buyMembership",this.data.params)
      const membership = await buyMembership(this.data.itemId, this.data.params)
      console.log("buyMembership", membership)
    },

    async bookClass(){
      console.log("bookClass" ,this.data)
      // createBooking()
    }

  }
})

// pages/booking/components/AccessOptions/AccessOptions.js
Component({
  /**
   * Component properties
   */
  properties: {
    session: Object,
    membershipTypes: Array,
    selected: String
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
    chooseOption({currentTarget}){
      const {bookingType} = currentTarget.dataset
      this.setData({selected: bookingType})
      this.triggerEvent('optionchanged', {selected: bookingType})
      
    }
  }
})

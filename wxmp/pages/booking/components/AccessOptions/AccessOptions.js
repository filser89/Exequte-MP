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
      // console.log(currentTarget.dataset)
      const {bookingType, membershipTypeId, membershipId} = currentTarget.dataset
      console.log(membershipTypeId)
      this.setData({selected: bookingType})
      this.triggerEvent('optionchanged', {
        selected: bookingType,
         selectedMembershipTypeId: membershipTypeId, 
         membershipId
        })
      
    }
  }
})

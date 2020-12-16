// components/PromoCode/PromoCode.js
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
    formSubmit ({detail}) {
      console.info( "Promocode", detail.value)
      const {promoCode} = detail.value
      console.log("Promocode logic goes here")
      // submit promocode to backend
    },
  }
})

// pages/booking/components/DateForm/DateForm.js
Component({
  /**
   * Component properties
   */
  properties: {
    dates: Array
  },

  /**
   * Component initial data
   */
  data: {
    index: 0
  },

  /**
   * Component methods
   */
  methods: {
    bindPickerChange({
      detail
    }) {
      console.log('picker value changed', detail.value)
      this.setData({
        index: detail.value
      })
      this.triggerEvent('datechanged', {
        membershipDateString: this.data.dates[this.data.index]
      })
    },

  }
})
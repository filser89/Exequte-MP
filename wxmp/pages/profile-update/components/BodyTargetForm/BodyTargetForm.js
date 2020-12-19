// pages/profile-update/components/BodyTargetForm/BodyTargetForm.js
Component({
  behaviors: ['wx://form-field-group'],

  /**
   * Component properties
   */
  properties: {
    user: Object
  },

  /**
   * Component initial data
   */
  data: {
    targets: ['lose', 'gain', 'maintain'],
    index: 0
  },

  /**
   * Component methods
   */
  methods: {
    bindTargetChange(e) {
      console.log('Activity Level', e.detail.value)
      this.setData({
        index: e.detail.value
      })
    }
  }
})

// pages/profile-update/components/ProfileForm/ProfileForm.j
const computedBehavior = require('miniprogram-computed')
Component({
  behaviors: ['wx://form-field-group'],
  /**
   * Component properties
   */
  properties: {
    user: Object,
    birthday: String
  },

  /**
   * Component initial data
   */
  data: {
    activityLevels: ['worker', 'desk'],
    index: 0
  },
  
  /**
   * Component methods
   */
  methods: {
    bindDateChange({detail}) {
      console.log('date-picker', detail.value)

      this.setData({birthday: detail.value})

    },
    bindActivityLevelChange(e) {
      console.log('Activity Level', e.detail.value)
      this.setData({
        index: e.detail.value
      })
    }
  }
})

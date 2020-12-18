// pages/profile-update/components/ProfileForm/ProfileForm.j
const computedBehavior = require('miniprogram-computed')
Component({
  behaviors: ['wx://form-field-group', computedBehavior],
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
    
  },
  // lifetimes: {
      
  //   attached() {
  //     this.setData({compUser: this.data.user})
  //     console.log("compUser", this.data.compUser)
  //   },
  // },
  // computed: {
  //   birthday(data) {
  //     if (data.user) return data.user.birthday
  //   },
  // },
  /**
   * Component methods
   */
  methods: {
    bindDateChange({detail}) {
      console.log('date-picker', detail.value)
      this.data.user.birthday = detail.value
  
      console.log("birthday", this.properties.user.birthday)
      console.log("user", this.properties.user)
      this.triggerEvent("birthdaychanged", {birthday: detail.value})


    },
  }
})

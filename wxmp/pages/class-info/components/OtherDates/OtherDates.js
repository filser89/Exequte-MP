// pages/class-info/components/OtherDates/OtherDates.js
import {getSessionDates} from '../../../../utils/requests/index'
Component({
  /**
   * Component properties
   */
  properties: {
    session: Object,
    selectedDateId: Number,
    selectedInstructorId: Number
  },

  /**
   * Component initial data
   */
  data: {
    datesShown: false
  },
  /**
   * Component methods
   */
  methods: {
   async showOtherDates(e){
     this.setData({datesShown: true})
     const {trainingId} = e.currentTarget.dataset

      this.setData({dates: await getSessionDates(trainingId)})
    },

    switchSelectedDate(e){
      const {sessionId, instructorId} = e.currentTarget.dataset
      this.setData({selectedDateId: sessionId, selectedInstructorId: instructorId})
    },
    hideOtherDates(){
      const detail = {
        sessionId: this.data.selectedDateId,
        instructorId: this.data.selectedInstructorId
      }
      this.triggerEvent('changeddate', detail)
      this.setData({datesShown: false})
    }
  }
})

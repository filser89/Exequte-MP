// components/ActionButton/ActionButton.js
Component({
  /**
   * Component properties
   */
  properties: {
    action: String
  },

  /**
   * Component initial data
   */
  data: {

  },
  lifetimes: {
    attached(){
      console.log("properties", this.properties)
    }
  },

  /**
   * Component methods
   */
  methods: {
    takeAction(e){
      const action =  e.currentTarget.dataset.action
      if(action == "bookClass"){
        this.bookClass()
      } else if(action == "queueUp"){
        this.queueUp()
      }

    },
    
    bookClass(){
      console.log("BOOK CLASS!!!")

    },

    queueUp(){
      console.log("QUEUE UP!!")
    }
  }
})

// components/TabBar/TabBar.js
Component({
  data: {
    selected: 1,
    color: "#7A7E83",
    selectedColor: "#3cc51f",
    list: [{
      pagePath: "../../pages/about/about",
      iconPath: "../../images/icon_component.png",
      selectedIconPath: "../../images/icon_component_HL.png",
      text: "about"
    }, {
      pagePath: "../../pages/index/index",
      iconPath: "../../images/icon_API.png",
      selectedIconPath: "../../images/icon_API_HL.png",
      text: "home"
    }, {
      pagePath: "../../pages/profile/profile",
      iconPath: "../../images/icon_API.png",
      selectedIconPath: "../../images/icon_API_HL.png",
      text: "profile"
    }]
  },
  ready() {
    this.setData({selected: wx.getStorageSync('selectedTab')})
    console.log('ready',this.data.selected)
  },
  methods: {
    switchTab({currentTarget}) {
      const url = currentTarget.dataset.path
      wx.switchTab({url})
    }
  }
})

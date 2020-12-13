//app.js
import { promisifyAll } from 'miniprogram-api-promise';

const wxp = {}
App({
  globalData: {
    ApiKey: 'ExeQuteapikey',
    BASE_URL: 'http://localhost:3000/api/v1',
    headers: {
      'API-Key': 'ExeQuteapikey'
    }
  },
  onLaunch: function () {

    promisifyAll(wx, wxp)
    const BASE_URL = 'http://localhost:3000/api/v1'
    const HEADERS = {
      'API-Key': 'ExeQuteapikey'
    }
    let data = wx.getStorageSync('current_user')
    // let x = wx.getStorageSync('current_xuser')
    if (data) {
      console.log(data)
      console.log('get user from storage, no need login')
      this.globalData.current_user = data.user,
      this.globalData.headers['X-Auth-Token'] = data.auth_token
    } else {
      this.login()
    }
    this.getPhoneLanguage()
    
    // // 获取用户信息
    // wx.getSetting({
    //   success: res => {
    //     if (res.authSetting['scope.userInfo']) {
    //       // 已经授权，可以直接调用 getUserInfo 获取头像昵称，不会弹框
    //       wx.getUserInfo({
    //         success: res => {
    //           // 可以将 res 发送给后台解码出 unionId
    //           this.globalData.userInfo = res.userInfo

    //           // 由于 getUserInfo 是网络请求，可能会在 Page.onLoad 之后才返回
    //           // 所以此处加入 callback 以防止这种情况
    //           if (this.userInfoReadyCallback) {
    //             this.userInfoReadyCallback(res)
    //           }
    //         }
    //       })
    //     }
    //   }
    // })
  },
  login: function() {
    let page = this;
    let headers = page.globalData.headers
    wx.login({
      success: res => {
        console.log(res)
        wx.request({
          url: `${page.globalData.BASE_URL}/users/wx_login`,
          method: 'post',
          header: headers,
          data: {code: res.code},
          success: user => {
            console.log(user.data)
            wx.setStorageSync('current_user', user.data.data)
            page.setToken(user.data.data)
          }
        })
      }
    })
  },
  setToken: function (data) {
    console.log(data)
    this.globalData.current_user = data.user,
    this.globalData.headers['X-Auth-Token'] = data.auth_token
    wx.reLaunch({
      url: '/pages/index/index',
    })
  },
  // get the user's phone language
async getPhoneLanguage() {
  const { language } = await wxp.getSystemInfo()
  console.log('lang:', language)
  return language
}

})
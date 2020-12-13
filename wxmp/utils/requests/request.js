import {
  promisifyAll,
  promisify
} from 'miniprogram-api-promise';

const app = getApp()
const wxp = {}
promisifyAll(wx, wxp)


const request = async (options) => {
  try {
    let resp = await wxp.request({
      url: `${app.globalData.BASE_URL}${options.url}`,
      method: options.method,
      header: app.globalData.headers,
      data: options.data
    })
    // return resp.statusCode === '200' ? resp.data.data : resp.data.error
    if (resp.statusCode === 200) {
      console.log(resp.data.data)
      return resp.data.data
    } else {
      throw new Error(resp.data.error.message)
    }
  } catch (e) {
    console.error(e.message)
  }
}

module.exports = {request}
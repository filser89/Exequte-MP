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
    console.log(resp.data.data)
    return resp.data.data
  } catch (e) {
    console.log('fail:', e)
  }
}
const setStrings = (keys) => {
  const options = {
    method: 'post',
    url: '/pages',
    data: keys
  }
  return request(options)
}

const getCurrentUser = async () => {
  const options = {
    method: 'get',
    url: '/users/info',
  }
return request(options)
}

const getMembershipTypes = () => {
  const options = {
    method: 'get',
    url: '/membership_types',
  }
  return request(options)
}

const buyMembership = () => {
  const options = {
    method: 'post',
    url: '/membership_types/1/memberships',
  }
  return request(options)
}

const addUserToQueue = () => {
  const options = {
    method: 'put',
    url: '/training_sessions/1/add_user_to_queue',
  }
  return request(options)
}

module.exports = {
  setStrings, 
  getCurrentUser,
  getMembershipTypes,
  buyMembership,
  addUserToQueue
}
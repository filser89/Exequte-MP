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
    url: '/training_sessions/32/add_user_to_queue',
  }
  return request(options)
}

const getInstructorSessions = () => {
  const options = {
    method: 'get',
    url: '/training_sessions/instructor_sessions',
  }
  return request(options)
}

const getAttendanceList = () => {
  const options = {
    method: 'get',
    url: '/training_sessions/32/bookings/attendance_list',
  }
  return request(options)
}

const createBooking = () => {
  const options = {
    method: 'post',
    url: '/training_sessions/32/bookings',
    data: {"booked_with": "voucher"}
  }
  return request(options)
}

const cancelBooking = () => {
  const options = {
    method: 'put',
    url: '/bookings/61/cancel',
  }
  return request(options)
}

const getSession = () => {
  const options = {
    method: 'get',
    url: '/training_sessions/34',
  }
  return request(options)
}

const getSessions = () => {
  const options = {
    method: 'get',
    url: '/training_sessions',
  }
  return request(options)
}

const takeAttendance = () => {
  const options = {
    method: 'put',
    url: '/bookings/take_attendance',
    data: [{id: 62, attended: true}]
  }
  return request(options)
}

module.exports = {
  setStrings, 
  getCurrentUser,
  getMembershipTypes,
  buyMembership,
  addUserToQueue,
  getInstructorSessions,
  getAttendanceList,
  createBooking,
  cancelBooking,
  getSession,
  getSessions,
  takeAttendance
}
import {request} from './request'

import {
  getInstructorSessions,
  getSession,
  getSessions,
  addUserToQueue
} from './sessions'

import {
  getAttendanceList,
  createBooking,
  cancelBooking,
  takeAttendance
} from './bookings.js'

import {
  getMembershipTypes,
  buyMembership
} from './memberships.js'

const getStrings = (keys) => {
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

const getBanner = async () => {
  const options = {
    method: 'get',
    url: '/banners',
  }
  return request(options)
}

module.exports = {
  getStrings,
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
  takeAttendance,
  getBanner
}
import {request} from './request'

import {
  getInstructorSessions,
  getSession,
  getSessions,
  addUserToQueue,
  getSessionDates
} from './sessions'

import {
  getBooking,
  getAttendanceList,
  createBooking,
  cancelBooking,
  takeAttendance,
  getUsersBookings
} from './bookings.js'

import {
  getMembershipTypes,
  buyMembership
} from './memberships.js'

import {
  getInstructor,
  getCurrentUser,
  getUserDetails
} from './users.js'

const getStrings = (keys) => {
  const options = {
    method: 'post',
    url: '/pages',
    data: keys
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
  getInstructor,
  getUserDetails,
  getMembershipTypes,
  buyMembership,
  addUserToQueue,
  getInstructorSessions,
  getBooking,
  getAttendanceList,
  createBooking,
  cancelBooking,
  getUsersBookings,
  getSession,
  getSessions,
  takeAttendance,
  getBanner,
  getSessionDates
}
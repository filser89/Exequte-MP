import {request} from './request'

const getAttendanceList = () => {
  const options = {
    method: 'get',
    url: '/training_sessions/32/bookings/attendance_list',
  }
  return request(options)
}

const createBooking = (sessionId) => {
  const options = {
    method: 'post',
    url: `/training_sessions/${sessionId}/bookings`,
    data: {
      booked_with: "membership",
      membership_id: 3
    }
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

const takeAttendance = () => {
  const options = {
    method: 'put',
    url: '/bookings/take_attendance',
    data: [{
      id: 62,
      attended: true
    }]
  }
  return request(options)
}
module.exports = {
  getAttendanceList,
  createBooking,
  cancelBooking,
  takeAttendance
}
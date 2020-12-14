import {request} from './request'

const getCurrentUser = async () => {
  const options = {
    method: 'get',
    url: '/users/info',
  }
  return request(options)
}

const getInstructor = async (id) => {
  const options = {
    method: 'get',
    url: `/users/${id}/instructor`,
  }
  return request(options)
}

module.exports = {
  getCurrentUser,
  getInstructor
}
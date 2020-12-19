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

const getUserDetails = async (id) => {
  const options = {
    method: 'get',
    url: `/users/${id}`,
  }
  return request(options)
}

const updateUser =  async (id, params) => {
  const options = {
    method: 'put',
    url: `/users/${id}`,
    data: {...params}
  }
  return request(options)
}

module.exports = {
  getCurrentUser,
  getInstructor,
  getUserDetails,
  updateUser
}
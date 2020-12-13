import {request} from './request'

const getInstructorSessions = () => {
  const options = {
    method: 'get',
    url: '/training_sessions/instructor_sessions',
  }
  return request(options)
}

const getSession = (id) => {
  const options = {
    method: 'get',
    url: `/training_sessions/${id}`,
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

const addUserToQueue = () => {
  const options = {
    method: 'put',
    url: '/training_sessions/32/add_user_to_queue',
  }
  return request(options)
}

module.exports = {
  getInstructorSessions,
  getSession,
  getSessions,
  addUserToQueue
}
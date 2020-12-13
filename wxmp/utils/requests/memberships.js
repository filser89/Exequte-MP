import {request} from './request'

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
    data: {
      start_date: new Date()
    }
  }
  return request(options)
}

module.exports = {
  getMembershipTypes,
  buyMembership
}
import {request} from './request'

const getMembershipTypes = () => {
  const options = {
    method: 'get',
    url: '/membership_types',
  }
  return request(options)
}

const buyMembership = (membershipTypeId, params) => {
  const options = {
    method: 'post',
    url: `/membership_types/${membershipTypeId}/memberships`,
    data: {
      ...params
    }
  }
  return request(options)
}

module.exports = {
  getMembershipTypes,
  buyMembership
}
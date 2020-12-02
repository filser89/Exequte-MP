module Api
  module V1
    class MembershipTypesController < Api::BaseController
      def index
        @membership_types = MembershipType.all
        render_success(@membership_types.map(&:standard_hash))
      end
    end
  end
end

module Api
  module V1
    class PagesController < Api::BaseController
      def make_strings
        puts "Inside make_strings"
        p request.headers['X-API-Lang']
        keys = params["_json"]
        strings = {}
        keys.each do |key|
          strings[key] = I18n.t(key)
        end
        render_success(strings)
      end
    end
  end
end

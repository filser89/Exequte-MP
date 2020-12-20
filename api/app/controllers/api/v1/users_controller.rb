module Api
  module V1
    class UsersController < Api::BaseController
      skip_before_action :authenticate_user_from_token!, only: [:wx_login]
      before_action :find_user, only: %i[show instructor update]
      def index
        # only for Admin user to check the users
        return render_success([]) unless current_user.admin

        @users = User.offset(offset_param).limit(per_param)
        render_success(@users.map(&:show_hash))
      end

      def show
        render_success(@user.show_hash)
      end

      def info
        render_success(current_user.info_hash)
      end

      def instructor
        render_success(@user.instructor_hash)
      end

      def update
        if @user.update(permitted_params)
          render_success({ message: 'Profile updated!', user: @user.standard_hash })
        else
          render_error({ message: 'Something went wrong' })
        end
      end

      def wx_login
        # every new user will login here and create a new user and issue an auth token
        js_code = params[:code]

        return render_error(I18n.t('errors.wechat.js_code_missing'), nil) unless js_code

        client = WechatOpenidService.new(js_code)

        return render_error(I18n.t('errors.wechat.wx_app_error')) unless client.error.nil?

        result = client.request

        return render_error(I18n.t('errors.wechat.tencent_error', nil)) if result['errcode']

        user = User.find_by(wx_open_id: result['openid'])
        if user
          puts "UPDATING"
          user.update(wx_session_key: result['session_key'])
        else
          puts "CREATING"
          user = User.create(wx_open_id: result['openid'], wx_session_key: result['session_key'])
        end

        auth_token = issue_jwt_token(user)
        render_success({ user: user.standard_hash, auth_token: auth_token })
      end

      private

      def find_user
        @user = User.find_by(id: params[:id])
      end

      def permitted_params
        params.require(:user).permit(:name, :email, :city, :phone, :wechat, :gender, :first_name, :last_name, :workout_name, :emergency_name, :emergency_phone, :favorite_song, :favorite_food, :music_styles, :profession, :profession_activity_level, :sports, :birthday, :nationality, :height, :current_weight, :current_body_fat, :current_shapes, :target, :target_weight, :target_body_fat, :target_shapes)
      end
    end
  end
end

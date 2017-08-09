require 'dotenv/load'
require 'facebook/messenger'
require 'unidecoder'
require_relative '../../app/helpers/vabbot_base/vabbotbase'
require_relative '../../app/helpers/vabbot_helper'
require_relative '../../app/helpers/nlp_helper'
include Facebook::Messenger
include VabbotHelper
include Unidecoder
include StringExtensions
include NLPHelper

############# START UP YOUR BOT, SET UP GREETING AND MENU ###################

Facebook::Messenger::Subscriptions.subscribe(access_token: ENV['ACCESS_TOKEN'])

# Enable "Get Started" button, greeting and persistent menu for your bot
VABBotBase::VABBotProfile.enable
VABBotBase::PersistentMenu.enable

############################################################################
location_replies = UI::QuickReplies.location
chuyenkhoan_replies = UI::QuickReplies.build(%w[Yes START_CHUYENKHOAN], %w[No STOP_CHUYENKHOAN])
chuyenkhoan_welcome = 'Thực hiện giao dịch chuyển khoản. Bạn đã sẵn sàng chưa?'

####################### ROUTE MESSAGES HERE ################################

Bot.on :message do |message|
    VABBotBase::MessageDispatch.new(message).route do

    # bind also takes regexps directly
    bind(/tên tôi/i, /tên/i, /ten/i, /ten toi/i, /chào/i, /chao/i, /hello/i, /xin chao/i, /xin chào/i, /hi/i) do
      user_info = get_user_info(:first_name)
      if user_info
        user_name = user_info[:first_name]
        user_email = user_info[:email]

        say "Xin chào #{user_name} #{user_email}  "
      else
        say 'Xin lỗi, chúng tôi chưa nhận ra dữ liệu Quý khách nhập. Vui lòng thử lại với từ "chào" hoặc "xin chào"'
      end
    end

    bind 'chuyen khoan', to: :start_chuyenkhoan, start_thread: {
    message: chuyenkhoan_welcome,
    quick_replies: chuyenkhoan_replies
    }

    # bind 'vị trí', to: :lookup_location, start_thread: {
    #   message: 'Cho biết vị trí của bạn',
    #   quick_replies: location_replies
    # }

    default do
      inputmsg = findFunction(message.text)
      #return unless !inputmsg.empty?
      say "Chúng tôi nhận ra có phải bạn muốn #{inputmsg} ?"
      #   return unless inputmsg.include?'CHUYEN KHOAN'
      #     say "yes, we know you"
      #     bind 'chuyen khoan', to: :start_chuyenkhoan, start_thread: {
      #     message: chuyenkhoan_welcome,
      #     quick_replies: chuyenkhoan_replies
      #     }
      # puts inputmsg
      end
      end
  end


######################## ROUTE POSTBACKS HERE ###############################

Bot.on :postback do |postback|
  VABBotBase::PostbackDispatch.new(postback).route do
    bind 'START' do
      say 'Ngân hàng TMCP Việt Á xin kính chào Quý khách!'
      say 'Đây là chương trình trợ lý hỗ trợ tự động VABBOT'
      say 'Vui lòng cho chúng tôi biết Quý khách cần hỗ trợ điều gì'
      say 'Quý khách có thể lựa chọn từ hệ thống Menu hoặc nhập vào phần hội thoại'
    end

    bind 'CAROUSEL', to: :show_carousel
    bind 'BUTTON_TINTUC', to: :show_button_tintuc
    bind 'BUTTON_TYGIA', to: :show_button_tygia

    bind 'vị trí', to: :lookup_location, start_thread: {
        message: 'Cho biết vị trí của bạn',
        quick_replies: location_replies
    }

    bind 'CHUYENKHOAN', to: :start_chuyenkhoan, start_thread: {
      message: chuyenkhoan_welcome,
      quick_replies: chuyenkhoan_replies
    }
  end
end
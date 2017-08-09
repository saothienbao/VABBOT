# rubocop:disable all

module VABBotBase
  # Sets up greeting screen for the bot
  class VABBotProfile
    def self.enable
      # Set call to action button when user is about to address bot
      # for the first time. Handle the payload in postbacks.
      Facebook::Messenger::Profile.set({
        get_started: {
          payload: 'START'
        }
      }, access_token: ENV['ACCESS_TOKEN'])

      # NOTE: You can user {{user_last_name}} or {{user_full_name}} to
      # personalize greeting.
      Facebook::Messenger::Profile.set({
        greeting: [
          {
            locale: 'default',
            text: "Xin chào, {{user_first_name}}!"
          },
          {
            locale: 'en_US',
            text: 'Hello, {{user_first_name}}!'
          }
        ]
      }, access_token: ENV['ACCESS_TOKEN'])
    end
  end
end

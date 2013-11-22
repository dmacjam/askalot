class Social
  include Squire::Base

  squire.source Rails.root.join('config', 'social.yml')

  squire.namespace Rails.env.to_sym, base: :defaults

  module ClassMethods
    def networks
      @networks ||= Hash[enabled.map { |key|
        network        = send(key)
        network.key    = key
        network.regexp = regexp(network.placeholder)

        [key, network]
      }]
    end

    private

    def regexp(placeholder)
      s = placeholder.clone

      s.gsub!(/\A(https?\:\/\/)?(www.)?/, '')
      s.gsub!(/[\.\/]/) { |c| '\\' + c }
      s.gsub!('userid', '(?<userid>[0-9]+)')
      s.gsub!('username', '(?<username>[a-zA-Z0-9\.\_\-]+)')

      /\Ahttps?\:\/\/?(www.)?#{s}\/?\z/
    end
  end

  extend ClassMethods
end
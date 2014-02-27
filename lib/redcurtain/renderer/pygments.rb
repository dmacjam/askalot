module Redcurtain::Renderer
  module Pygments
    extend self

    def render(content, options = {})
      document = Nokogiri::HTML(content.to_s)

      document.search('//pre').each do |pre|
        pre.replace ::Pygments.highlight(pre.text.strip, lexer: pre[:lang])
      end

      document.to_s.html_safe
    end
  end
end
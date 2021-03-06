require "uri"
require "nokogiri"
require "open-uri"

module ApplicationHelper
  def text_url_to_link(text)
    safe_text = h(text)

    URI.extract(safe_text, ['http', 'https']).uniq.each do |url|
      sub_text = ""
      sub_text << "<a href=" << url << " target='_blank'>" << url << "</a>"

      safe_text.gsub!(url, sub_text)
    end
    safe_text
  end

  # contribution graph用
  # collectionを渡すとcolumnの日ごとに整理されたhashになって返ってくる
  def calendarize_data(collection, column: :created_at)
    Hash.new([]).tap do |hash|
      collection.each do |c|
        date = c.send(column).in_time_zone('Tokyo').to_date
        hash[date] = [] if hash[date].empty?
        hash[date] << c
      end
    end
  end

  # returns proxy url only in production mode
  def proxy(url)
    host = Rails.application.config.x.imageproxy.host
    key = Rails.application.config.x.imageproxy.secret_key

    if key && host
      digest = OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha256'), key, url)
      signature = Base64.urlsafe_encode64(digest).strip()
      "#{host}/s#{signature}/#{url}"
    else
      url
    end
  end
end

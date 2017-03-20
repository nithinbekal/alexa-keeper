class Alexarank < ApplicationRecord
  belongs_to :website

  scope :timeline, -> {order(created_at: :desc)}

  def self.fetch_rank domain:
    alexa_link  = 'http://www.alexa.com/siteinfo/'+ domain
    doc  = Nokogiri::HTML(open(alexa_link))
    rank = doc.css('strong.metrics-data.align-vmiddle')
              .inner_text.to_s.gsub(',', '')
              .split
              .first
    rank.to_i
  

  end
end

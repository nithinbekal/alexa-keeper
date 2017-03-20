module StaticPagesHelper
    def self.createJSON(website)
        series = []
        website.each do |site|
            demo_series = {}
            ranks = []
            data  = []
            category = []
            
            site.fetch_last_10_days_rank.each do |rank|
                create_data = {}
                category << rank.created_at.strftime('%Y-%m-%d')
                create_data = { name: rank.created_at.strftime('%Y-%m-%d'), y: rank.rank.to_i }
                data.push(create_data)
            end
            demo_series = { name: site.url, data: data, date: category.uniq }
            series.push(demo_series)
        end
        series = series.map { |o| Hash[o.each_pair.to_a] }
    end
end

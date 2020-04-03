require 'acts_as_seoable/sitemap_seo'

module SitemapClassMethods

  def create_sitemap_seo_records
    Rails.application.reload_routes!
    routes = Rails.application.routes.routes.select { |r| r.defaults.include? :sitemap}
    row_routes = Array.new

    routes.each do |route|
      next if route.defaults[:sitemap] != true
      row = SitemapSeo.find_by_sitemap_controller_and_sitemap_action(route.defaults[:controller], route.defaults[:action])
      if row.nil?
        new_row = SitemapSeo.create(sitemap_controller: route.defaults[:controller], sitemap_action: route.defaults[:action],
                                    status: false)
        row_routes << new_row
      else
        row_routes << row
      end
    end

    SitemapSeo.all.each do |sitemap_seo|
      next if (row_routes.include? sitemap_seo) || sitemap_seo.sitemap_controller == 'host'

      sitemap_seo.delete
    end
  end
end

require 'mongoid'

module Wiki
  class Page
    include Mongoid::Document
    include Mongoid::Paranoia
    include Mongoid::Timestamps
    include Mongoid::Versioning

    field :name
    field :slug
    field :body

    class Entity < Grape::Entity
      expose :slug, :documentation => { :type => "string", :desc => "Unique page slug." }
      expose :name, :documentation => { :type => "string", :desc => "Page name." }
      expose :body, :documentation => { :type => "string", :desc => "Page body." }
    end
   
    after_initialize do |page|
      page.slug ||= Page.slug_from_name(page.name)
      page.name ||= Page.name_from_slug(page.slug)
    end

    validates :name, presence: true
    validates :slug, presence: true, uniqueness: true

    class Parser < Creole::Parser
      def make_local_link(link)
        page = Page.where(slug: Page.slug_from_name(link)).first_or_initialize
        
        if page.persisted?
          "/#{page.slug}"
        else
          "/#{page.slug}/edit"
        end
      end
    end

    def html
      Parser.new(self.body.to_s).to_html
    end

    class << self
      def name_from_slug(slug)
        slug.to_s.humanize
      end

      def slug_from_name(name)
        name.to_s.humanize.gsub(/\s+/, '_')
      end
    end
  end
end

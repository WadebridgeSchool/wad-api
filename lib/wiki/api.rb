require 'grape'

require 'wiki/page'

module Wiki
  class API < Grape::API
    version 'v1'

    format :json

    resource :pages do
      desc 'Return a wiki page.'
      params do
        requires :slug, type: String, desc: 'Page slug.'
      end
      get ':slug' do
        page = Page.where(slug: params[:slug]).first

        present page, with: Page::Entity
      end

      desc 'Create a new wiki page.'
    end
  end
end

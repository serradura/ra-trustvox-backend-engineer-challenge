# frozen_string_literal: true

#
# HATEOAS = Hypermedia as the Engine of Application State
#
module HATEOAS
  LinkToGet = -> (rel, builder:) do
    -> data do
      { rel: rel, href: builder.(data['id']), method: 'GET' }
    end
  end

  SetLinks = -> link_builders do
    builders = Array(link_builders)

    -> data { data.merge!(_links: builders.map { |build| build[data] }) }
  end
end

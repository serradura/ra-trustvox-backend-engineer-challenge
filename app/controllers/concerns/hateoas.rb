# frozen_string_literal: true

module HATEOAS # Hypermedia as the Engine of Application State
  LinkToGet = -> (rel, builder:) do
    -> data do
      { rel: rel, href: builder.(data['id']), type: 'GET' }
    end
  end

  Links = -> link_builders do
    builders = Array(link_builders)

    -> data { data.merge!(_links: builders.map { |build| build[data] }) }
  end
end

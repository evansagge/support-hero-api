ActiveSupport::Inflector.inflections(:en) do |inflect|
  inflect.plural(/^(hero)$/i, '\1\2es')
  inflect.singular(/^(hero)es$/i, '\1')
end

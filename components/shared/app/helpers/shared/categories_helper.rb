module Shared::CategoriesHelper
  def group_categories_by_prefix(categories)
    mixed  = []
    groups = categories.inject(Hash.new) do |groups, category|
      if match = category.name.match(/[A-Z]{2,}\s/)
        (groups[match[0].strip.downcase.to_sym] ||= []) << category
      else
        mixed << category
      end

      groups
    end

    groups.sort_by { |key, _| key }
    groups[:mixed] = mixed
    groups
  end

  def link_to_category(category, options = {})
    link_to category.name, shared.questions_path(tags: category.tags.join(',')), options
  end

  def names_for_teachers(teachers)
    text = teachers.length == 1 ? t('user.teacher_followed_category.one') : t('user.teacher_followed_category.more')

    text << teachers.map { |t| t.name }.join(', ')
  end

  def recursive_tree_table(root_category)
    "<table class=\"treegrid table\"><tr class=\"treegrid-404\"><td>Root</td></tr>#{recursive_tree_table_level(root_category.children)}</table>"
  end

  def recursive_tree_table_level(categories)
    res = ''
    categories.each do |category|
      res << "<tr class=\"treegrid-#{category.id} treegrid-parent-#{category.parent_id}\">"
      res << "<td>#{category.name}</td>"
      res << "</tr>\n"
      res << recursive_tree_table_level(category.children)
    end
    res
  end
end

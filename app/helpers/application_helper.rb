module ApplicationHelper
  extend Deprecation
  
  ##
  # Link to the previous document in the current search context
  #
  # Custom method to override link_to_previous_document so we can change its classes to match Bootstrap's pagination component
  def ual_link_to_previous_document(previous_document, classes: 'previous page-link', **addl_link_opts)
    link_opts = session_tracking_params(previous_document, search_session['counter'].to_i - 1).merge(class: classes, rel: 'prev').merge(addl_link_opts)
    link_to_unless previous_document.nil?, raw(t('views.pagination.previous')), url_for_document(previous_document), link_opts do
      tag.span raw(t('views.pagination.previous')), class: 'previous page-link'
    end
  end
  deprecation_deprecate link_to_previous_document: 'Moving to Blacklight::SearchContextComponent'

  ##
  # Link to the next document in the current search context
  #
  # Custom method to override link_to_next_document so we can change its classes to match Bootstrap's pagination component
  def ual_link_to_next_document(next_document, classes: 'next page-link', **addl_link_opts)
    link_opts = session_tracking_params(next_document, search_session['counter'].to_i + 1).merge(class: classes, rel: 'next').merge(addl_link_opts)
    link_to_unless next_document.nil?, raw(t('views.pagination.next')), url_for_document(next_document), link_opts do
      tag.span raw(t('views.pagination.next')), class: 'next page-link'
    end
  end
  deprecation_deprecate link_to_previous_document: 'Moving to Blacklight::SearchContextComponent'

  # Create a link back to the index screen, keeping the user's facet, query and paging choices intact by using session.
  # @example
  #   link_back_to_catalog(label: 'Back to Search')
  #   link_back_to_catalog(label: 'Back to Search', route_set: my_engine)
  def ual_link_back_to_catalog(opts = { label: nil })
    scope = opts.delete(:route_set) || self
    query_params = search_state.reset(current_search_session.try(:query_params)).to_hash

    if search_session['counter']
      per_page = (search_session['per_page'] || blacklight_config.default_per_page).to_i
      counter = search_session['counter'].to_i

      query_params[:per_page] = per_page unless search_session['per_page'].to_i == blacklight_config.default_per_page
      query_params[:page] = ((counter - 1) / per_page) + 1
    end

    link_url = if query_params.empty?
                 search_action_path(only_path: true)
               else
                 scope.url_for(query_params)
               end
    label = opts.delete(:label)

    if link_url =~ /bookmarks/
      label ||= t('blacklight.back_to_bookmarks').html_safe
    end

    label ||= t('blacklight.back_to_search').html_safe

    link_to label, link_url, opts
  end
  
end

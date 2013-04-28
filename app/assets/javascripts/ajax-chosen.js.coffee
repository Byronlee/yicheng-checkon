do ($ = jQuery) ->

  $.fn.ajaxChosen = (settings = {}, callback, chosenOptions = {}) ->
    defaultOptions =
      minTermLength: 1
      afterTypeDelay: 500
      jsonTermKey: "term"
      keepTypingMsg: "输入.."
      lookingForMsg: "查询中.."
      no_results_text:"没有"

    select = @

    chosenXhr = null
    options = $.extend {}, defaultOptions, $(select).data(), settings
    @chosen(if chosenOptions then chosenOptions else {})

    @each ->
      $(@).next('.chzn-container')
        .find(".search-field > input, .chzn-search > input")
        .bind 'keyup', ->

          untrimmed_val = $(@).val()
          val = $.trim $(@).val()

          msg = if val.length < options.minTermLength then options.keepTypingMsg else options.lookingForMsg + " '#{val}'"
          select.next('.chzn-container').find('.no-results').text(msg)

          # If input text has not changed ... do nothing
          return false if val is $(@).data('prevVal')

          # Set the current search term so we don't execute the ajax call if
          # the user hits a key that isn't an input letter/number/symbol
          $(@).data('prevVal', val)

          # At this point, we have a new term/query ... the old timer
          # is no longer valid.  Clear it.

          # We delay searches by a small amount so that we don't flood the
          # server with ajax requests.
          clearTimeout(@timer) if @timer

          # Some simple validation so we don't make excess ajax calls. I am
          # assuming you don't want to perform a search with less than 3
          # characters.
          return false if val.length < options.minTermLength

          # This is a useful reference for later
          field = $(@)

          # Default term key is `term`.  Specify alternative in options.options.jsonTermKey
          options.data = {} unless options.data?
          options.data[options.jsonTermKey] = val
          options.data = options.dataCallback(options.data) if options.dataCallback?

          # If the user provided an ajax success callback, store it so we can
          # call it after our bootstrapping is finished.
          success = options.success

          # Create our own callback that will be executed when the ajax call is
          # finished.
          options.success = (data) ->
            # Exit if the data we're given is invalid
            return unless data?

            # Go through all of the <option> elements in the <select> and remove
            # ones that have not been selected by the user.  For those selected
            # by the user, add them to a list to filter from the results later.
            selected_values = []
            select.find('option').each ->
              if not $(@).is(":selected")
                $(@).remove()
              else
                selected_values.push $(@).val() + "-" + $(@).text()
            select.find('optgroup:empty').each ->
              $(@).remove()


            # Send the ajax results to the user callback so we can get an object of
            # value => text pairs to inject as <option> elements.
            items = if callback? then callback(data, field) else data


            nbItems = 0

            # Iterate through the given data and inject the <option> elements into
            # the DOM if it doesn't exist in the selector already
            $.each items, (i, element) ->
              nbItems++

              if element.group
                group = select.find("optgroup[label='#{element.text}']")
                group = $("<optgroup />") unless group.size()

                group.attr('label', element.text)
                  .appendTo(select)
                $.each element.items, (i, element) ->
                  if typeof element == "string"
                    value = i;
                    text = element;
                  else
                    value = element.value;
                    text = element.text;
                  if $.inArray(value + "-" + text, selected_values) == -1
                    $("<option />")
                      .attr('value', value)
                      .html(text)
                      .appendTo(group)
              else
                if typeof element == "string"
                  value = i;
                  text = element;
                else
                  value = element.value;
                  text = element.text;
                if $.inArray(value + "-" + text, selected_values) == -1
                  $("<option />")
                    .attr('value', value)
                    .html(text)
                    .appendTo(select)

            if nbItems
              select.trigger("liszt:updated")
            else

              select.data().chosen.no_results_clear()
              select.data().chosen.no_results field.val()

            settings.success(data) if settings.success?

            field.val(untrimmed_val)

          @timer = setTimeout ->
            chosenXhr.abort() if chosenXhr
            chosenXhr = $.ajax(options)
          , options.afterTypeDelay
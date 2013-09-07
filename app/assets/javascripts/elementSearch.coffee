jQuery ($) ->

  $('#content-search input').typeahead([{
      name: 'stories',
      prefetch: 'assets/examples/stories.json',
      template: [
        '<p class="content-id">{{id}}</p>',
        '<p class="content-description">{{description}}</p>',
      ].join(''),
      engine: Hogan,
    }, {
      name: 'forces',
      prefetch: 'assets/examples/forces.json',
      template: [
        '<p class="content-id">{{id}}</p>',
        '<p class="content-description">{{description}}</p>',
      ].join(''),
      engine: Hogan,
    }, {
      name: 'solution components',
      prefetch: 'assets/examples/solutionComponents.json',
      template: [
        '<p class="content-id">{{id}}</p>',
        '<p class="content-description">{{description}}</p>',
      ].join(''),
      engine: Hogan,
    }]
  )


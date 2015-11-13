#= require reveal.js/lib/js/head.min
#= require reveal.js/js/reveal
#= require moment

# <!-- Sets date using Moment.js -->
# today = moment().format('dddd, MMMM Do')
# # document.getElementById('now').innerHTML = now;
# document.getElementById('today').innerHTML = today

# <!-- Gets objects from a google doc -->


Reveal.initialize
  width: "90%"
  height: "100%"
  controls: false
  progress: false
  history: true
  center: true
  # autoSlide: 8000
  loop: true
  autoSlideStoppable: false
  theme: Reveal.getQueryHash().theme # available themes are in /css/theme
  transition: Reveal.getQueryHash().transition or "default" # default/cube/page/concave/zoom/linear/fade/none

  # Optional libraries used to extend on reveal.js
  dependencies: [
    {
      # src: "/javascripts/reveal.js/plugin/markdown/marked.js"
      src: "javascripts/reveal.js/plugin/markdown/marked.js"
      condition: ->
        !!document.querySelector("[data-markdown]")
    }
    {
      # src: "/javascripts/reveal.js/plugin/markdown/markdown.js"
      src: "javascripts/reveal.js/plugin/markdown/markdown.js"
      condition: ->
        !!document.querySelector("[data-markdown]")
    }
    {
      # src: '/javascripts/reveal.js/plugin/highlight/highlight.js'
      src: 'javascripts/reveal.js/plugin/highlight/highlight.js'
      async: true
      callback: ->
        hljs.initHighlightingOnLoad()
    }
  ]

# { src: 'lib/js/classList.js', condition: function() { return !document.body.classList; } },
# { src: 'plugin/highlight/highlight.js', async: true, callback: function() { hljs.initHighlightingOnLoad(); } },
# { src: 'plugin/zoom-js/zoom.js', async: true, condition: function() { return !!document.body.classList; } },
# { src: 'plugin/notes/notes.js', async: true, condition: function() { return !!document.body.classList; } }

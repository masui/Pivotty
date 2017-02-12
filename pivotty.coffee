movieData = {}

MovieInfo = React.createClass
  render: ->
    url = movieData['data'][this.props.id]['image_url']
    title = movieData['data'][this.props.id]['Title']

    imagestyle =
      position: 'absolute'
      top: this.props.top + 140
      left: this.props.left + 20
      height: 300
    titlestyle =
      position: 'absolute'
      top: this.props.top + 20
      left: this.props.left + 20
      width: 200

    <div>
      <div style={titlestyle} >{title}</div>
      <img style={imagestyle} src={url} />
    </div>

PivottyApp = React.createClass
  getInitialState: ->
    id: 0
 
  changeRank: (rank) ->
    id = movieData['indices']['imdbVotes'][rank]
    this.setState
      id: id

  changeTitle: (title) ->
    id = movieData['indices']['Title'][title]
    this.setState
      id: id

  render: ->
    <div>
      <Slider top=70 left=280 height=400 maxvalue=400 onChange={this.changeTitle} />
      <Slider top=70 left=380 height=400 maxvalue=4000 onChange={this.changeRank} />

      <MovieInfo top=0 left=0 id={this.state.id} />
    </div>

data_received = (d, status, xhr) ->
  movieData = d
  React.render <PivottyApp />, pivotty

$ ->
  $.ajax
    async:     true
    type:      "GET"
    url:       "movies.json" # データはhttp://pivotty.nikezono.net/data から
    dataType:  "json"
    context:    this
    success:   data_received
    error:     (xhr,  status, error) -> alert status
    # complete:  data_received
    

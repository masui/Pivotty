movieData = {}

Slider = React.createClass
  getInitialState: ->
    state = 
      top: this.props.top         # 親から渡された値
      left: this.props.left
      height: 400                 # スライダの長さ
      value: 200                  # ノブの値
      clicked: false

  onMouseDown: (e) ->
    e.preventDefault()
    this.state.mousedowny = e.pageY
    this.state.mousedownx = e.pageX
    this.state.downvalue = this.state.value
    this.state.clicked = true
    $(document).bind 'mousemove', this.onMouseMove
    $(document).bind 'mouseup', this.onMouseUp
    return

  onMouseUp: (e) ->
    e.preventDefault()
    if this.state.clicked
      this.state.clicked = false
      $(document).unbind 'mousemove', this.onMouseMove
      $(document).unbind 'mouseup', this.onMouseUp

  onMouseMove: (e) ->
    e.preventDefault()
    if this.state.clicked
      value = this.state.downvalue - e.pageY + this.state.mousedowny
      value = 0 if value < 0
      value = 400 if value > 400
      this.props.onChange value  # 親に通知... こうやるものだっけ?
      this.setState
        value: value

  render: ->
    sliderstyle =
      backgroundColor: "#ff0"
      position: 'absolute'
      top: -100 + this.state.height - this.state.value
      left: this.state.left
      width: 20
      height: 400
    knob =
      position: 'absolute'
      width: 80
      height:20
      left: -30
      top: this.state.value
      backgroundColor: "#ccf8"

    <div style={sliderstyle} onMouseDown={this.onMouseDown}>
      <div style={knob}>
      </div>
    </div>

MovieInfo = React.createClass
  render: ->
    url = movieData['data'][this.props.id]['image_url']
    title = movieData['data'][this.props.id]['Title']
    # $('#span1').text title

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
      <Slider top=70 left=280 onChange={this.changeTitle} />
      <Slider top=70 left=380 onChange={this.changeRank} />

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
    

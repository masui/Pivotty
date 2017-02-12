movieData = {}

Slider = React.createClass
  getInitialState: ->
    state = 
      top: this.props.top         # 親から渡された値
      left: this.props.left
      height: 400                 # スライダの長さ
      value: 200                  # ノブの値
      clicked: false
      onChange: this.props.onChange

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
      this.state.onChange value  # 親に通知... こうやるものだっけ?
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
    style =
      position: 'absolute'
      top: this.props.top
      left: this.props.left
      height: 300

    <img style={style} src={url} />

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

      <MovieInfo top=140 left=30 id={this.state.id} />
    </div>

data_received = (d, status, xhr) ->
  movieData = d
  React.render <PivottyApp />, pivotty

$ ->
  $.ajax
    async:     true
    type:      "GET"
    url:       "movies.json"
    dataType:  "json"
    context:    this
    success:   data_received
    error:     (xhr,  status, error) -> alert status
    # complete:  data_received
    
# データはhttp://pivotty.nikezono.net/data
# {
#   "data": [
#     {
#       "Title": "Jumanji",
#       "Year": "1995",
#       "Rated": "PG",
#       "Released": "15 Dec 1995",
#       "Runtime": "104 min",
#       "Genre": "Adventure, Family, Fantasy",
#       "Director": "Joe Johnston",
#       "Writer": "Jonathan Hensleigh (screenplay),...",
#       "Actors": "Robin Williams, Jonathan Hyde, Kirsten Dunst, Bradley Pierce",
#       "Plot": "When two kids find and play a magical board game, ...",
#       "Language": "English, French",
#       "Country": "USA",
#       "Awards": "4 wins & 9 nominations.",
#       "image_url": "http://ia.media-imdb.com/images/M/MV5BMTk5MjAyNTM4Ml5BMl5BanBnXkFtZTgwMjY0MDI0MjE@._V1_SX300.jpg",
#       "Metascore": "39",
#       "imdbRating": "6.9",
#       "imdbVotes": "190,920",
#       "imdbID": "tt0113497",
#       "Type": "movie",
#       "Response": "True",
#       "id": "1"
#     },
#     ...


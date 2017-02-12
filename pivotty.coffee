data = {}

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
    #$('#span2').text('DOWN')
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
      #$('#span2').text('UP')
      this.state.clicked = false
      $(document).unbind 'mousemove', this.onMouseMove
      $(document).unbind 'mouseup', this.onMouseUp

  onMouseMove: (e) ->
    e.preventDefault()
    if this.state.clicked
      # value = this.state.downvalue + e.pageY - this.state.mousedowny
      value = this.state.downvalue - e.pageY + this.state.mousedowny
      value = 0 if value < 0
      value = 400 if value > 400
      i = data['indices']['imdbVotes'][value]
      # $('#span1').text data['data'][i]['Title']
      # $('#image').attr 'src', data['data'][i]['image_url']
      this.state.onChange value
      this.setState
        value: value
        #mousex: e.pageX - this.state.mousedownx # マウス移動量
        #mousey: e.pageY - this.state.mousedowny

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
      width: 100
      height:20
      left: -50
      top: this.state.value
      backgroundColor: "#ccf8"

    <div style={sliderstyle} onMouseDown={this.onMouseDown}>
      <div style={knob}>
      </div>
    </div>

MovieInfo = React.createClass
  render: ->
    i = data['indices']['imdbVotes'][this.props.rank]
    url = data['data'][i]['image_url']
    style =
      position: 'absolute'
      top: this.props.top
      left: this.props.left
      height: 300

    <img style={style} src={url} />

PivottyApp = React.createClass
  getInitialState: ->
    top: this.props.top
    left: this.props.left
    rank: 0
    title: 0

#    items: this.props.zzz
#    #items: [1, 2, 3]   # this.state.items がセットされる

  changeRank: (rank) ->
    this.setState
      rank: rank

  render: ->
    <div>
      <Slider top=100 left=100 onChange={this.changeRank} />
      <Slider top=100 left=200 onChange={this.changeRank} />

      <MovieInfo top=400 left=400 rank={this.state.rank} />
    </div>

data_received = (d, status, xhr) ->
  data = d
  React.render <PivottyApp top=0 left=0 />, pivotty

# i = data['indices']['imdbVotes'][0]
# alert data['data'][i]['Title']
# alert data['data'][0]['Title']

# データはhttp://pivotty.nikezono.net/data
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
    
#  React.render <PivottyApp top=0 left=0 />, pivotty
  
#  React.render <Slider top=100 left=100 />, sliderdiv1
#  React.render <Slider top=100 left=200 />, sliderdiv2


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
#       "Writer": "Jonathan Hensleigh (screenplay), Greg Taylor (screenplay), Jim Strain (screenplay), Greg Taylor (screen story), Jim Strain (screen story), Chris Van Allsburg (screen story), Chris Van Allsburg (book)",
#       "Actors": "Robin Williams, Jonathan Hyde, Kirsten Dunst, Bradley Pierce",
#       "Plot": "When two kids find and play a magical board game, they release a man trapped for decades in it and a host of dangers that can only be stopped by finishing the game.",
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


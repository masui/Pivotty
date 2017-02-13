movieData = {}

MovieInfo = React.createClass
  render: ->
    url = movieData['data'][this.props.id]['image_url']
    title = movieData['data'][this.props.id]['Title']
    director = movieData['data'][this.props.id]['Director']
    actor = movieData['data'][this.props.id]['Actors']

    imagestyle =
      position: 'absolute'
      top: this.props.top + 180
      left: this.props.left + 20
      width: 200
    titlestyle =
      position: 'absolute'
      top: this.props.top + 20
      left: this.props.left + 20
      width: 200
    directorstyle =
      position: 'absolute'
      top: this.props.top + 70
      left: this.props.left + 20
      width: 200
    actorstyle =
      position: 'absolute'
      top: this.props.top + 100
      left: this.props.left + 20
      width: 200

    <div>
      <div style={titlestyle} >{title}</div>
      <div style={directorstyle} >{director}</div>
      <div style={actorstyle} >{actor}</div>
      <img style={imagestyle} src={url} />
    </div>

MovieImage = React.createClass
  render: ->
    url = movieData['data'][this.props.id]['image_url']
    imagestyle =
      position: 'absolute'
      top: this.props.top
      left: this.props.left
      width: 80

    <div>
      <img style={imagestyle} src={url} />
    </div>

#MovieColumn = React.createClass
#  getInitialState: ->
#    state = 
#      top: this.props.top
#      left: this.props.left
#      id: this.props.id
#      titleValue: 10000
#      rankValue: 10000
#      
#  findValue: (array, id) -> # あるidのデータが何番目かを馬鹿サーチする... 逆インデクスを最初に作るべきかも
#    for i in [0...array.length]
#      if array[i] == id
#        return i
# 
#  changeRank: (rank) ->
#    id = movieData['indices']['imdbVotes'][rank]
#    titleValue = this.findValue movieData['indices']['Title'], id
#    this.setState
#      id: id
#      titleValue: titleValue
#      rankValue: null
#
#  render: ->
#    columnstyle =
#      backgroundColor: "#ffd"
#      position: 'absolute'
#      top: this.state.top
#      left: this.state.left
#      width: 130
#      height: 500
#      
#    id = this.props.id
#    rankValue = this.findValue this.props.array, id
#    id2 = this.props.array[rankValue-2]
#    id1 = this.props.array[rankValue-1]
#
#    <div style={columnstyle}>
#      <Slider top=70 left=10 height=400 maxvalue=30106 onChange={this.changeRank} value={this.state.rankValue} />
#      <MovieImage top=50 left=50 id={id2} />
#      <MovieImage top=170 left=50 id={id1} />
#    </div>

PivottyApp = React.createClass
  getInitialState: ->
    id: 10000
    titleValue: 10000
    rankValue: 10000
    directorValue: 10000
    actorValue: 10000

  findValue: (array, id) -> # あるidのデータが何番目かを馬鹿サーチする... 逆インデクスを最初に作るべきかも
    for i in [0...array.length]
      if array[i] == id
        return i
 
  changeRank: (rank) ->
    id = movieData['indices']['imdbVotes'][rank]
    titleValue = this.findValue movieData['indices']['Title'], id
    directorValue = this.findValue movieData['indices']['Director'], id
    actorValue = this.findValue movieData['indices']['Actors'], id
    this.setState
      id: id
      titleValue: titleValue
      rankValue: null
      directorValue: directorValue
      actorValue: directorValue

  changeTitle: (title) ->
    id = movieData['indices']['Title'][title]
    rankValue = this.findValue movieData['indices']['imdbVotes'], id
    directorValue = this.findValue movieData['indices']['Director'], id
    actorValue = this.findValue movieData['indices']['Actors'], id
    this.setState
      id: id
      rankValue: rankValue
      directorValue: directorValue
      titleValue: null
      actorValue: actorValue

  changeDirector: (director) ->
    id = movieData['indices']['Director'][director]
    titleValue = this.findValue movieData['indices']['Title'], id
    rankValue = this.findValue movieData['indices']['imdbVotes'], id
    actorValue = this.findValue movieData['indices']['Actors'], id
    this.setState
      id: id
      rankValue: rankValue
      titleValue: titleValue
      directorValue: null
      actorValue: actorValue

  changeActor: (actor) ->
    id = movieData['indices']['Actors'][actor]
    titleValue = this.findValue movieData['indices']['Title'], id
    rankValue = this.findValue movieData['indices']['imdbVotes'], id
    directorValue = this.findValue movieData['indices']['Director'], id
    this.setState
      id: id
      rankValue: rankValue
      titleValue: titleValue
      directorValue: directorValue
      actorValue: null

  render: ->
    id = this.state.id
    
    titleValue = this.findValue movieData['indices']['Title'], id
    id11 = movieData['indices']['Title'][titleValue-2]
    id12 = movieData['indices']['Title'][titleValue-1]
    id13 = movieData['indices']['Title'][titleValue+1]
    id14 = movieData['indices']['Title'][titleValue+2]
    
    rankValue = this.findValue movieData['indices']['imdbVotes'], id
    id21 = movieData['indices']['imdbVotes'][rankValue-2]
    id22 = movieData['indices']['imdbVotes'][rankValue-1]
    id23 = movieData['indices']['imdbVotes'][rankValue+1]
    id24 = movieData['indices']['imdbVotes'][rankValue+2]
    
    directorValue = this.findValue movieData['indices']['Director'], id
    id31 = movieData['indices']['Director'][directorValue-2]
    id32 = movieData['indices']['Director'][directorValue-1]
    id33 = movieData['indices']['Director'][directorValue+1]
    id34 = movieData['indices']['Director'][directorValue+2]
    
    actorValue = this.findValue movieData['indices']['Actors'], id
    id41 = movieData['indices']['Actors'][actorValue-2]
    id42 = movieData['indices']['Actors'][actorValue-1]
    id43 = movieData['indices']['Actors'][actorValue+1]
    id44 = movieData['indices']['Actors'][actorValue+2]
    
    <div>
      <MovieImage top=50  left=305 id={id11} />
      <MovieImage top=170 left=305 id={id12} />
      <Slider top=70 left=280 height=400 maxvalue=30106 onChange={this.changeTitle} value={this.state.titleValue} />
      <MovieImage top=330 left=305 id={id13} />
      <MovieImage top=450 left=305 id={id14} />

      <MovieImage top=50  left=425 id={id21} />
      <MovieImage top=170 left=425 id={id22} />
      <Slider top=70 left=400 height=400 maxvalue=30106 onChange={this.changeRank} value={this.state.rankValue} />
      <MovieImage top=330 left=425 id={id23} />
      <MovieImage top=450 left=425 id={id24} />
        
      <MovieImage top=50  left=545 id={id31} />
      <MovieImage top=170 left=545 id={id32} />
      <Slider top=70 left=520 height=400 maxvalue=30106 onChange={this.changeDirector} value={this.state.directorValue} />
      <MovieImage top=330 left=545 id={id33} />
      <MovieImage top=450 left=545 id={id34} />
        
      <MovieImage top=50  left=665 id={id41} />
      <MovieImage top=170 left=665 id={id42} />
      <Slider top=70 left=640 height=400 maxvalue=30106 onChange={this.changeActor} value={this.state.actorValue} />
      <MovieImage top=330 left=665 id={id43} />
      <MovieImage top=450 left=665 id={id44} />
        
      <MovieInfo top=0 left=0 id={id} />
    </div>
      
#      <MovieColumn top=100 left=380 height=400 id={id} array={movieData['indices']['imdbVotes']} />
  
      

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

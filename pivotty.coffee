# coding: utf-8

movieData = {}
oldcolumn = -1
sayTimeout = null

findValue = (array, id) ->
  for i in [0...array.length]
    if array[i] == id
      return i

VoiceInfo = React.createClass
  render: ->
    title = movieData['data'][this.props.id]['Title']
    director = movieData['data'][this.props.id]['Director']
    actor = movieData['data'][this.props.id]['Actors']
    plot = movieData['data'][this.props.id]['Plot']
    
    rankValue = findValue movieData['indices']['imdbVotes'], this.props.id
    
    actors = actor.split ','
    text = ""
    column = this.props.column
    if column != oldcolumn
      switch this.props.column
        when 0
          text = "Title: "
        when 1
          text = "Rank: "
        when 2
          text = "Director: "
        when 3
          text = "Actor: "
    oldcolumn = column

    switch this.props.column
      when 0
        text += title
      when 1
        text += "#{title}: #{rankValue}"
      when 2
        text += "#{director}: #{title}"
      when 3
        text += "#{actors[0]}: #{title}"

    say =  ->
      $.ajax
        async:     true
        type:      "GET"
        url:       "say.cgi"
        data:
          text: encodeURIComponent text
          level: 100
        context:    this
    sayTimeout = setTimeout say, 300

    <div></div>
    
MovieInfo = React.createClass
  render: ->
    url = "images/#{movieData['data'][this.props.id]['id']}.jpg"
    title = movieData['data'][this.props.id]['Title']
    director = movieData['data'][this.props.id]['Director']
    actor = movieData['data'][this.props.id]['Actors']
    plot = movieData['data'][this.props.id]['Plot']
    replaceImage = =>
      ReactDOM.findDOMNode(this.refs.image).src = "images/empty.png"

    imagestyle =
      position: 'absolute'
      top: this.props.top + 180
      left: this.props.left + 20
      width: 200
    titlestyle =
      position: 'absolute'
      top: this.props.top + 10
      left: this.props.left + 20
      width: 250
      fontWeight: 'bold'
      fontSize: 20
    directorstyle =
      position: 'absolute'
      top: this.props.top + 80
      left: this.props.left + 20
      width: 250
    actorstyle =
      position: 'absolute'
      top: this.props.top + 110
      left: this.props.left + 20
      width: 250
    plotstyle =
      position: 'absolute'
      top: this.props.top + 500
      left: this.props.left + 20
      width: 250

    <div>
      <div style={titlestyle}>{title}</div>
      <div style={directorstyle}>監督: {director}</div>
      <div style={actorstyle}>出演: {actor}</div>
      <img style={imagestyle} ref="image" src={url} onError={replaceImage} />
      <div style={plotstyle}>あらすじ: {plot}</div>
    </div>

MovieImage = React.createClass
  render: ->
    # url = movieData['data'][this.props.id]['image_url']
    # url = "images/#{this.props.id+1}.jpg"
    url = "images/#{movieData['data'][this.props.id]['id']}.jpg"
    replaceImage = =>
      ReactDOM.findDOMNode(this.refs.image).src = "images/empty.png"
    imagestyle =
      position: 'absolute'
      top: this.props.top
      left: this.props.left
      width: 80
    if url != "N/A"
      <div>
        <img style={imagestyle} src={url} ref="image" onError={replaceImage} />
      </div>
    else
      <img style={imagestyle} src="images/2571.jpg" />

PivottyApp = React.createClass

  preventDefault: (e) ->
    e.preventDefault()

  getInitialState: ->
    $(document).on 'keydown', this.keyDown
    $(document).on 'mousewheel', this.mouseWheel
    $(document).on 'mousedown', this.mouseDown
    $(document).on 'contextmenu', this.preventDefault # 右クリックでメニューが出ないようにする
    
    id = 2570
    rankValue = this.findValue movieData['indices']['imdbVotes'], id
    titleValue = this.findValue movieData['indices']['Title'], id
    directorValue = this.findValue movieData['indices']['Director'], id
    actorValue = this.findValue movieData['indices']['Actors'], id
    state =
      id: id
      titleValue: titleValue
      rankValue: rankValue
      directorValue: directorValue
      actorValue: actorValue
      column: 0

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

  mouseDown: (e) ->
    e.preventDefault()
    column = this.state.column
    switch e.button
      when 0 # left
        column = column-1 if column > 0
        this.setState
          column: column
      when 2 # right
        column = column+1 if column < 3
        this.setState
          column: column
    this.do_updown 0, column
    return false
    
  mouseWheel: (e) ->
    e.preventDefault()
    column = this.state.column
    this.do_updown -1, column if e.deltaY == 1
    this.do_updown 1, column if e.deltaY == -1
    
  keyDown: (e) ->
    e.preventDefault()
    clearTimeout sayTimeout
    column = this.state.column
    updown = 0
    switch e.keyCode
      when 39 # right
        column = column+1 if column < 3
        this.setState
          column: column
      when 37 # left
        column = column-1 if column > 0
        this.setState
          column: column
      when 38 # up
        updown = 1
      when 40 # down
        updown = -1
    this.do_updown updown, column

  do_updown: (updown,column) ->
    if updown != 0
      switch column
        when 0 # Title
          id = this.state.id
          titleValue = this.findValue movieData['indices']['Title'], id
          titleValue += updown
          titleValue = 0 if titleValue < 0
          titleValue = 30106 if titleValue > 30106
          newid = movieData['indices']['Title'][titleValue]
          rankValue = this.findValue movieData['indices']['imdbVotes'], newid
          directorValue = this.findValue movieData['indices']['Director'], newid
          actorValue = this.findValue movieData['indices']['Actors'], newid
        when 1 # Rank
          id = this.state.id
          rankValue = this.findValue movieData['indices']['imdbVotes'], id
          rankValue += updown
          rankValue = 0 if rankValue < 0
          rankValue = 30106 if rankValue > 30106
          newid = movieData['indices']['imdbVotes'][rankValue]
          titleValue = this.findValue movieData['indices']['Title'], newid
          directorValue = this.findValue movieData['indices']['Director'], newid
          actorValue = this.findValue movieData['indices']['Actors'], newid
        when 2 # Director
          id = this.state.id
          directorValue = this.findValue movieData['indices']['Director'], id
          directorValue += updown
          directorValue = 0 if directorValue < 0
          directorValue = 30106 if directorValue > 30106
          newid = movieData['indices']['Director'][directorValue]
          titleValue = this.findValue movieData['indices']['Title'], newid
          rankValue = this.findValue movieData['indices']['imdbVotes'], newid
          actorValue = this.findValue movieData['indices']['Actors'], newid
        when 3
          id = this.state.id
          actorValue = this.findValue movieData['indices']['Actors'], id
          actorValue += updown
          actorValue = 0 if actorValue < 0
          actorValue = 30106 if actorValue > 30106
          newid = movieData['indices']['Actors'][actorValue]
          titleValue = this.findValue movieData['indices']['Title'], newid
          rankValue = this.findValue movieData['indices']['imdbVotes'], newid
          directorValue = this.findValue movieData['indices']['Director'], newid
      this.setState
        id: newid
        rankValue: rankValue
        titleValue: titleValue
        directorValue: directorValue
        actorValue: actorValue

  render: ->
    id = this.state.id

    a = movieData['indices']['Title']
    v = this.findValue a, id
    id11 = a[v-2]
    id12 = a[v-1]
    id13 = a[v+1]
    id14 = a[v+2]
    titleValue = v
    
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

    columnstyle =
      backgroundColor: "#ddd"
      position: 'absolute'
      top: 0
      left: this.state.column * 120 + 280
      width: 120
      height: 640

    <div>
      <div style={columnstyle} />
      
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

      <div style={position:'absolute', top:25, left:315}>タイトル</div>
      <span style={position:'absolute', top:25, left:435}>ランキング</span>
      <span style={position:'absolute', top:25, left:555}>監督</span>
      <span style={position:'absolute', top:25, left:675}>出演</span>
        
      <MovieInfo top=0 left=0 id={id} />

      <VoiceInfo id={id} column={this.state.column} />
    </div>

data_received = (d, status, xhr) ->
  movieData = d
  ReactDOM.render <PivottyApp />, pivotty

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

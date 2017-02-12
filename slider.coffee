Slider = React.createClass
  createTable: ->
    for i in [0..this.state.height]
      this.state.table[i] = i

  getInitialState: ->
    state = 
      top: this.props.top               # 親から渡された値
      left: this.props.left
      height: this.props.height         # スライダの長さ
      knobpos: this.props.height / 2
      maxvalue: this.props.maxvalue
      value: this.props.maxvalue / 2
      clicked: false
      table: {}

  onMouseDown: (e) ->
    e.preventDefault()
    this.createTable()
    this.state.mousedowny = e.pageY
    this.state.mousedownx = e.pageX
    this.state.downvalue = this.state.value
    this.state.downknobpos = this.state.knobpos
    this.state.clicked = true
    $(document).bind 'mousemove', this.onMouseMove
    $(document).bind 'mouseup', this.onMouseUp

  onMouseUp: (e) ->
    e.preventDefault()
    if this.state.clicked
      this.state.clicked = false
      $(document).unbind 'mousemove', this.onMouseMove
      $(document).unbind 'mouseup', this.onMouseUp

  onMouseMove: (e) ->
    e.preventDefault()
    if this.state.clicked
      yoffset = this.state.downknobpos - e.pageY + this.state.mousedowny
      # value = knobpos # ここに微調整を入れる e.g. value = table[knobpos]
      value = this.state.table[yoffset]
      value = 0 if value < 0
      value = this.state.maxvalue if value > this.state.maxvalue
      this.props.onChange value  # 親に通知... こうやるものだっけ?
      this.setState
        knobpos: value
        value: value

  render: ->
    sliderstyle =
      backgroundColor: "#ff0"
      position: 'absolute'
      top: 300 - this.state.knobpos # ノブ位置が300のとき
      left: this.state.left
      width: 20
      height: this.props.height
    knob =
      position: 'absolute'
      width: 80
      height:20
      left: -30
      top: this.state.knobpos
      backgroundColor: "#ccf8"

    <div style={sliderstyle} onMouseDown={this.onMouseDown}>
      <div style={knob}>
        {this.state.value}
      </div>
    </div>

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

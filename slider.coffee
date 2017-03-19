Slider = React.createClass
  table: {}

  getInitialState: ->
    state = 
      top: this.props.top               # 親から渡された値
      left: this.props.left
      height: this.props.height         # スライダの長さ
      #knobpos: this.props.height / 2
      maxvalue: this.props.maxvalue
      value: this.props.value
      clicked: false

  onMouseDown: (e) ->
    e.preventDefault()
    this.table = new SmoothSnapTable
    this.table.reset()
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
      yoffset = -e.pageY + this.state.mousedowny      # マウスの移動量
      yoffset = Math.floor yoffset
      #
      # ここで微調整計算
      #
      value = this.state.downvalue + this.table.table[yoffset]                # 新しい値設定
      value = 0 if value < 0
      value = this.state.maxvalue if value > this.state.maxvalue
      this.props.value = value
      this.props.onChange value                                               # 新しい値を親に通知
      this.setState
        value: value

  render: ->
    if this.props.value
      value = this.props.value
      this.state.value = value
    else
      value = this.state.value
    knobpos = this.state.height * value / this.state.maxvalue
    sliderstyle =
      backgroundColor: "#ff0"
      position: 'absolute'
      top: 300 - knobpos # ノブ位置が300のとき
      left: this.state.left
      width: 20
      height: this.props.height
    knobstyle =
      position: 'absolute'
      width: 120
      height:20
      left: 0
      top: knobpos                                                 # スライダ移動
      backgroundColor: "#ccf8"

    <div style={sliderstyle} onMouseDown={this.onMouseDown}>
      <div style={knobstyle}>
        {value}
      </div>
    </div>

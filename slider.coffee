Slider = React.createClass
  createTable: ->
    val = 0
    for i in [0..40]
      this.state.table[i] = val
      val += 1
    for i in [41..80]
      this.state.table[i] = val
      val += 10
    for i in [81..120]
      this.state.table[i] = val
      val += 100
    for i in [121..160]
      this.state.table[i] = val
      val += 1000
    val = 0
    for i in [0..40]
      this.state.table[-i] = val
      val -= 1
    for i in [41..80]
      this.state.table[-i] = val
      val -= 10
    for i in [81..120]
      this.state.table[-i] = val
      val -= 100
    for i in [121..160]
      this.state.table[-i] = val
      val -= 1000

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
      yoffset = -e.pageY + this.state.mousedowny      # マウスの移動量
      yoffset = Math.floor yoffset
      #
      # ここで微調整計算
      #
      value = this.state.downvalue + this.state.table[yoffset]                # 新しい値設定
      value = 0 if value < 0
      value = this.state.maxvalue if value > this.state.maxvalue
      this.props.onChange value                                               # 新しい値を親に通知
      this.setState
        knobpos: this.state.height * value / this.state.maxvalue
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
      top: this.state.knobpos                                                 # スライダ移動
      backgroundColor: "#ccf8"

    <div style={sliderstyle} onMouseDown={this.onMouseDown}>
      <div style={knob}>
        {this.state.value}
      </div>
    </div>

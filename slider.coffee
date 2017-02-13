Slider = React.createClass
  createTable: ->
    val = 0.0
    for i in [0..20]
      this.state.table[i] = Math.floor val
      val += 0.2
    for i in [21..40]
      this.state.table[i] = Math.floor val
      val += 0.5
    for i in [41..80]
      this.state.table[i] = Math.floor val
      val += 5.0
    for i in [81..120]
      this.state.table[i] = Math.floor val
      val += 50.0
    for i in [121..160]
      this.state.table[i] = Math.floor val
      val += 500.0
    val = 0.0
    for i in [0..20]
      this.state.table[-i] = Math.floor val
      val -= 0.2
    for i in [21..40]
      this.state.table[-i] = Math.floor val
      val -= 0.5
    for i in [41..80]
      this.state.table[-i] = Math.floor val
      val -= 5.0
    for i in [81..120]
      this.state.table[-i] = Math.floor val
      val -= 50.0
    for i in [121..160]
      this.state.table[-i] = Math.floor val
      val -= 500.0

  getInitialState: ->
    state = 
      top: this.props.top               # 親から渡された値
      left: this.props.left
      height: this.props.height         # スライダの長さ
      #knobpos: this.props.height / 2
      maxvalue: this.props.maxvalue
      value: this.props.value
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

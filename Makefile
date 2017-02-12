slider:
	cjsx -cb pivotty.coffee
data:
	wget http://pivotty.nikezono.net/data
	mv data /tmp/tmpdata
	jq . < /tmp/tmpdata > movies.json

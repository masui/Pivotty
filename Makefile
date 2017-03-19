slider:
	cjsx -cb pivotty.coffee
	cjsx -cb slider.coffee
	cjsx -cb table.coffee
data:
	wget http://pivotty.nikezono.net/data
	mv data /tmp/tmpdata
	jq . < /tmp/tmpdata > movies.json
upload:
	cd ..; scp Pivotty/*.{html,js,rb} pitecan.com:/www/www.pitecan.com/tmp/Pivotty
upload_all:
	cd ..; scp -r Pivotty pitecan.com:/www/www.pitecan.com/tmp

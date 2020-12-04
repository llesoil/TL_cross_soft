#!/bin/sh

numb='2062'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --slow-firstpass --weightb --aq-strength 1.0 --ipratio 1.1 --pbratio 1.1 --psy-rd 4.8 --qblur 0.3 --qcomp 0.7 --vbv-init 0.2 --aq-mode 3 --b-adapt 2 --bframes 0 --crf 10 --keyint 220 --lookahead-threads 3 --min-keyint 28 --qp 30 --qpstep 3 --qpmin 0 --qpmax 68 --rc-lookahead 38 --ref 5 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan show --preset veryslow --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--weightb,1.0,1.1,1.1,4.8,0.3,0.7,0.2,3,2,0,10,220,3,28,30,3,0,68,38,5,2000,-2:-2,hex,show,veryslow,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"
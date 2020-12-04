#!/bin/sh

numb='1613'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --slow-firstpass --weightb --aq-strength 0.5 --ipratio 1.0 --pbratio 1.0 --psy-rd 2.2 --qblur 0.3 --qcomp 0.8 --vbv-init 0.3 --aq-mode 1 --b-adapt 2 --bframes 8 --crf 30 --keyint 230 --lookahead-threads 2 --min-keyint 30 --qp 30 --qpstep 3 --qpmin 2 --qpmax 69 --rc-lookahead 38 --ref 6 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan show --preset placebo --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--weightb,0.5,1.0,1.0,2.2,0.3,0.8,0.3,1,2,8,30,230,2,30,30,3,2,69,38,6,1000,-1:-1,hex,show,placebo,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"
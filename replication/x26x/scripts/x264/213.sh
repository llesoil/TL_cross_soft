#!/bin/sh

numb='214'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --slow-firstpass --weightb --aq-strength 1.5 --ipratio 1.5 --pbratio 1.0 --psy-rd 2.2 --qblur 0.2 --qcomp 0.6 --vbv-init 0.8 --aq-mode 1 --b-adapt 0 --bframes 10 --crf 10 --keyint 280 --lookahead-threads 4 --min-keyint 23 --qp 20 --qpstep 5 --qpmin 0 --qpmax 66 --rc-lookahead 38 --ref 2 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan show --preset faster --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--weightb,1.5,1.5,1.0,2.2,0.2,0.6,0.8,1,0,10,10,280,4,23,20,5,0,66,38,2,1000,1:1,dia,show,faster,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"
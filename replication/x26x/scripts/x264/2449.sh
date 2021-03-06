#!/bin/sh

numb='2450'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --slow-firstpass --no-weightb --aq-strength 2.0 --ipratio 1.1 --pbratio 1.1 --psy-rd 0.4 --qblur 0.6 --qcomp 0.8 --vbv-init 0.2 --aq-mode 1 --b-adapt 2 --bframes 0 --crf 30 --keyint 200 --lookahead-threads 4 --min-keyint 25 --qp 30 --qpstep 5 --qpmin 3 --qpmax 67 --rc-lookahead 38 --ref 2 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan show --preset slower --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--no-weightb,2.0,1.1,1.1,0.4,0.6,0.8,0.2,1,2,0,30,200,4,25,30,5,3,67,38,2,1000,-2:-2,umh,show,slower,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"
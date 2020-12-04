#!/bin/sh

numb='332'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-weightb --aq-strength 1.0 --ipratio 1.2 --pbratio 1.3 --psy-rd 2.0 --qblur 0.5 --qcomp 0.6 --vbv-init 0.0 --aq-mode 2 --b-adapt 2 --bframes 4 --crf 15 --keyint 280 --lookahead-threads 1 --min-keyint 26 --qp 30 --qpstep 4 --qpmin 1 --qpmax 68 --rc-lookahead 48 --ref 2 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan show --preset slow --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--no-weightb,1.0,1.2,1.3,2.0,0.5,0.6,0.0,2,2,4,15,280,1,26,30,4,1,68,48,2,2000,-2:-2,hex,show,slow,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"
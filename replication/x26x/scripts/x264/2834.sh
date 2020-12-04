#!/bin/sh

numb='2835'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --weightb --aq-strength 2.5 --ipratio 1.2 --pbratio 1.3 --psy-rd 4.0 --qblur 0.4 --qcomp 0.8 --vbv-init 0.6 --aq-mode 3 --b-adapt 0 --bframes 2 --crf 45 --keyint 210 --lookahead-threads 1 --min-keyint 21 --qp 20 --qpstep 3 --qpmin 0 --qpmax 66 --rc-lookahead 28 --ref 6 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan crop --preset placebo --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--weightb,2.5,1.2,1.3,4.0,0.4,0.8,0.6,3,0,2,45,210,1,21,20,3,0,66,28,6,1000,-1:-1,hex,crop,placebo,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"
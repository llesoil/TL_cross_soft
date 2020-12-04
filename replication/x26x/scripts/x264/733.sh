#!/bin/sh

numb='734'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --slow-firstpass --weightb --aq-strength 0.5 --ipratio 1.3 --pbratio 1.1 --psy-rd 4.6 --qblur 0.5 --qcomp 0.8 --vbv-init 0.9 --aq-mode 0 --b-adapt 1 --bframes 12 --crf 20 --keyint 210 --lookahead-threads 1 --min-keyint 21 --qp 40 --qpstep 4 --qpmin 2 --qpmax 62 --rc-lookahead 38 --ref 3 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan crop --preset slower --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--weightb,0.5,1.3,1.1,4.6,0.5,0.8,0.9,0,1,12,20,210,1,21,40,4,2,62,38,3,2000,-1:-1,hex,crop,slower,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"
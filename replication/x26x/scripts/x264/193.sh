#!/bin/sh

numb='194'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --slow-firstpass --no-weightb --aq-strength 0.5 --ipratio 1.5 --pbratio 1.2 --psy-rd 3.4 --qblur 0.5 --qcomp 0.6 --vbv-init 0.8 --aq-mode 2 --b-adapt 2 --bframes 0 --crf 20 --keyint 290 --lookahead-threads 2 --min-keyint 21 --qp 10 --qpstep 4 --qpmin 1 --qpmax 60 --rc-lookahead 18 --ref 2 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan crop --preset slow --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--no-weightb,0.5,1.5,1.2,3.4,0.5,0.6,0.8,2,2,0,20,290,2,21,10,4,1,60,18,2,2000,1:1,hex,crop,slow,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"
#!/bin/sh

numb='1145'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --slow-firstpass --no-weightb --aq-strength 1.5 --ipratio 1.5 --pbratio 1.4 --psy-rd 4.2 --qblur 0.5 --qcomp 0.8 --vbv-init 0.8 --aq-mode 3 --b-adapt 2 --bframes 12 --crf 20 --keyint 210 --lookahead-threads 2 --min-keyint 24 --qp 0 --qpstep 3 --qpmin 2 --qpmax 61 --rc-lookahead 28 --ref 4 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan crop --preset placebo --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--no-weightb,1.5,1.5,1.4,4.2,0.5,0.8,0.8,3,2,12,20,210,2,24,0,3,2,61,28,4,1000,-2:-2,umh,crop,placebo,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"
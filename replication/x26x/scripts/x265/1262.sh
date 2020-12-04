#!/bin/sh

numb='1263'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-weightb --aq-strength 0.0 --ipratio 1.0 --pbratio 1.3 --psy-rd 4.8 --qblur 0.3 --qcomp 0.8 --vbv-init 0.3 --aq-mode 0 --b-adapt 1 --bframes 16 --crf 35 --keyint 200 --lookahead-threads 0 --min-keyint 26 --qp 0 --qpstep 5 --qpmin 2 --qpmax 68 --rc-lookahead 18 --ref 6 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan show --preset placebo --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--no-weightb,0.0,1.0,1.3,4.8,0.3,0.8,0.3,0,1,16,35,200,0,26,0,5,2,68,18,6,1000,-2:-2,hex,show,placebo,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"
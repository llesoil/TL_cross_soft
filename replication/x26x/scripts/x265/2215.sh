#!/bin/sh

numb='2216'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --slow-firstpass --weightb --aq-strength 3.0 --ipratio 1.5 --pbratio 1.3 --psy-rd 5.0 --qblur 0.3 --qcomp 0.9 --vbv-init 0.4 --aq-mode 3 --b-adapt 2 --bframes 16 --crf 25 --keyint 300 --lookahead-threads 3 --min-keyint 28 --qp 0 --qpstep 5 --qpmin 1 --qpmax 60 --rc-lookahead 18 --ref 4 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan show --preset slower --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--weightb,3.0,1.5,1.3,5.0,0.3,0.9,0.4,3,2,16,25,300,3,28,0,5,1,60,18,4,1000,-2:-2,hex,show,slower,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"
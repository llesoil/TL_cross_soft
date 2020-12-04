#!/bin/sh

numb='733'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --slow-firstpass --no-weightb --aq-strength 0.5 --ipratio 1.0 --pbratio 1.1 --psy-rd 3.2 --qblur 0.3 --qcomp 0.8 --vbv-init 0.9 --aq-mode 3 --b-adapt 2 --bframes 0 --crf 20 --keyint 290 --lookahead-threads 1 --min-keyint 28 --qp 50 --qpstep 4 --qpmin 2 --qpmax 69 --rc-lookahead 18 --ref 5 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan show --preset veryfast --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--no-weightb,0.5,1.0,1.1,3.2,0.3,0.8,0.9,3,2,0,20,290,1,28,50,4,2,69,18,5,1000,-2:-2,dia,show,veryfast,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"
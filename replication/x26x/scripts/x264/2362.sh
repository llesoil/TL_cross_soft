#!/bin/sh

numb='2363'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-weightb --aq-strength 1.5 --ipratio 1.0 --pbratio 1.3 --psy-rd 2.6 --qblur 0.5 --qcomp 0.6 --vbv-init 0.4 --aq-mode 0 --b-adapt 1 --bframes 14 --crf 0 --keyint 200 --lookahead-threads 2 --min-keyint 20 --qp 50 --qpstep 5 --qpmin 1 --qpmax 69 --rc-lookahead 18 --ref 3 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan show --preset fast --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--no-weightb,1.5,1.0,1.3,2.6,0.5,0.6,0.4,0,1,14,0,200,2,20,50,5,1,69,18,3,2000,-1:-1,dia,show,fast,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"
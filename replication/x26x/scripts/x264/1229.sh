#!/bin/sh

numb='1230'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-weightb --aq-strength 0.0 --ipratio 1.2 --pbratio 1.2 --psy-rd 0.2 --qblur 0.5 --qcomp 0.7 --vbv-init 0.7 --aq-mode 2 --b-adapt 2 --bframes 4 --crf 50 --keyint 200 --lookahead-threads 2 --min-keyint 22 --qp 10 --qpstep 5 --qpmin 1 --qpmax 67 --rc-lookahead 28 --ref 4 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan crop --preset veryfast --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--no-weightb,0.0,1.2,1.2,0.2,0.5,0.7,0.7,2,2,4,50,200,2,22,10,5,1,67,28,4,2000,-1:-1,dia,crop,veryfast,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"
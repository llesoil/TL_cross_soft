#!/bin/sh

numb='174'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --no-weightb --aq-strength 0.5 --ipratio 1.6 --pbratio 1.3 --psy-rd 3.6 --qblur 0.4 --qcomp 0.8 --vbv-init 0.6 --aq-mode 0 --b-adapt 0 --bframes 2 --crf 25 --keyint 280 --lookahead-threads 4 --min-keyint 24 --qp 30 --qpstep 4 --qpmin 1 --qpmax 66 --rc-lookahead 18 --ref 3 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan show --preset veryfast --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--no-weightb,0.5,1.6,1.3,3.6,0.4,0.8,0.6,0,0,2,25,280,4,24,30,4,1,66,18,3,1000,-1:-1,umh,show,veryfast,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"
#!/bin/sh

numb='790'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --intra-refresh --weightb --aq-strength 0.0 --ipratio 1.2 --pbratio 1.3 --psy-rd 4.4 --qblur 0.2 --qcomp 0.8 --vbv-init 0.1 --aq-mode 1 --b-adapt 2 --bframes 2 --crf 15 --keyint 240 --lookahead-threads 0 --min-keyint 26 --qp 20 --qpstep 3 --qpmin 1 --qpmax 60 --rc-lookahead 18 --ref 1 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan crop --preset ultrafast --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,--intra-refresh,None,None,--weightb,0.0,1.2,1.3,4.4,0.2,0.8,0.1,1,2,2,15,240,0,26,20,3,1,60,18,1,1000,-1:-1,hex,crop,ultrafast,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"
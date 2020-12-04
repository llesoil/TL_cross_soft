#!/bin/sh

numb='469'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-weightb --aq-strength 0.0 --ipratio 1.0 --pbratio 1.2 --psy-rd 0.6 --qblur 0.6 --qcomp 0.8 --vbv-init 0.6 --aq-mode 3 --b-adapt 1 --bframes 0 --crf 50 --keyint 250 --lookahead-threads 1 --min-keyint 24 --qp 30 --qpstep 3 --qpmin 0 --qpmax 64 --rc-lookahead 38 --ref 5 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan crop --preset veryfast --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--no-weightb,0.0,1.0,1.2,0.6,0.6,0.8,0.6,3,1,0,50,250,1,24,30,3,0,64,38,5,2000,1:1,umh,crop,veryfast,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"
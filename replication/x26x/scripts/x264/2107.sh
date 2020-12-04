#!/bin/sh

numb='2108'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-weightb --aq-strength 0.5 --ipratio 1.3 --pbratio 1.1 --psy-rd 2.4 --qblur 0.4 --qcomp 0.6 --vbv-init 0.5 --aq-mode 0 --b-adapt 1 --bframes 2 --crf 25 --keyint 300 --lookahead-threads 2 --min-keyint 25 --qp 40 --qpstep 4 --qpmin 4 --qpmax 69 --rc-lookahead 28 --ref 1 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan crop --preset veryfast --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--no-weightb,0.5,1.3,1.1,2.4,0.4,0.6,0.5,0,1,2,25,300,2,25,40,4,4,69,28,1,2000,-2:-2,umh,crop,veryfast,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"
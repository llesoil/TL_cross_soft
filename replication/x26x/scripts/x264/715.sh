#!/bin/sh

numb='716'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --weightb --aq-strength 1.5 --ipratio 1.1 --pbratio 1.1 --psy-rd 4.2 --qblur 0.5 --qcomp 0.6 --vbv-init 0.1 --aq-mode 2 --b-adapt 1 --bframes 14 --crf 20 --keyint 300 --lookahead-threads 3 --min-keyint 22 --qp 20 --qpstep 4 --qpmin 3 --qpmax 68 --rc-lookahead 18 --ref 5 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan crop --preset veryfast --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--weightb,1.5,1.1,1.1,4.2,0.5,0.6,0.1,2,1,14,20,300,3,22,20,4,3,68,18,5,2000,1:1,dia,crop,veryfast,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"
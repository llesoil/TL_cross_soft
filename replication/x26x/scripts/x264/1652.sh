#!/bin/sh

numb='1653'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-weightb --aq-strength 2.0 --ipratio 1.2 --pbratio 1.3 --psy-rd 3.4 --qblur 0.4 --qcomp 0.9 --vbv-init 0.6 --aq-mode 0 --b-adapt 0 --bframes 8 --crf 10 --keyint 230 --lookahead-threads 0 --min-keyint 28 --qp 40 --qpstep 4 --qpmin 0 --qpmax 64 --rc-lookahead 48 --ref 5 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan show --preset fast --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--no-weightb,2.0,1.2,1.3,3.4,0.4,0.9,0.6,0,0,8,10,230,0,28,40,4,0,64,48,5,2000,-1:-1,dia,show,fast,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"
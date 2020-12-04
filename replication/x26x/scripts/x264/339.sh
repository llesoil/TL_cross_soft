#!/bin/sh

numb='340'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --slow-firstpass --no-weightb --aq-strength 1.0 --ipratio 1.3 --pbratio 1.2 --psy-rd 2.6 --qblur 0.4 --qcomp 0.7 --vbv-init 0.0 --aq-mode 1 --b-adapt 2 --bframes 8 --crf 20 --keyint 200 --lookahead-threads 1 --min-keyint 27 --qp 40 --qpstep 5 --qpmin 0 --qpmax 60 --rc-lookahead 18 --ref 1 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan crop --preset faster --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--no-weightb,1.0,1.3,1.2,2.6,0.4,0.7,0.0,1,2,8,20,200,1,27,40,5,0,60,18,1,1000,-2:-2,dia,crop,faster,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"